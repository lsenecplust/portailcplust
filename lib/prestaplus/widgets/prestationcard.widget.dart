import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/action.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class PrestationCard extends StatelessWidget {
  final Prestation prestation;
  const PrestationCard({
    Key? key,
    required this.prestation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    handlemodalresult(value) {
      if (value != null) {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          autoHide: const Duration(seconds: 2),
          dialogType: value is NotFound ? DialogType.info : DialogType.error,
          showCloseIcon: true,
          title: value is NotFound
              ? 'Aucune action possible sur cette prestation'
              : 'Error',
          desc: value is NotFound ? "" : value.toString(),
          btnOkIcon: Icons.check_circle,
        ).show();
      }
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (BuildContext subcontext) {
            return ActionModalSheet(
              prestation: prestation,
              oauthContext: context,
            );
          },
        ).then(handlemodalresult);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          boxShadow: [
            BoxShadow(
                color: lightColorScheme.primary,
                offset: const Offset(-7, 0),
                blurRadius: 0,
                spreadRadius: 0),
            const BoxShadow(
                color: CustomColors.gray400,
                offset: Offset(2, 2),
                blurRadius: 2,
                spreadRadius: 2.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${prestation.numPrestation} ",
                  ),
                  Text(
                    DateFormat('EEE d MMM yyyy - HH:mm')
                        .format(prestation.dateRdv),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prestation.idRdvPxo,
                    style: const TextStyle(color: CustomColors.gray500),
                  ),
                  Text(
                    prestation.contactFullname,
                    style: const TextStyle(color: CustomColors.gray500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    prestation.clientNom,
                    style: TextStyle(color: lightColorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionModalSheet extends StatefulWidget {
  final Prestation prestation;
  final BuildContext? oauthContext;
  final double tileHeight;
  const ActionModalSheet({
    Key? key,
    required this.prestation,
    this.oauthContext,
    this.tileHeight = 100,
  }) : super(key: key);

  @override
  State<ActionModalSheet> createState() => _ActionModalSheetState();
}

class _ActionModalSheetState extends State<ActionModalSheet> {
  double spacing = 80;
  late double height = widget.tileHeight + spacing;
  late Future<List<MigAction>> future =
      getActions(widget.oauthContext ?? context);
  goto(MigAction action, BuildContext context) {
    Navigator.of(context).pop();
    OAuthManager.of(context)?.navigatePush(
        context,
        ActionEquipementScreen(
            prestation: widget.prestation, migAction: action));
  }

  Future<List<MigAction>> getActions(context) async {
    var resp =
        await widget.prestation.getActions(widget.oauthContext ?? context);
    setState(() {
      if (resp.length <= 2) {
        height = widget.tileHeight + spacing;
      } else {
        height = widget.tileHeight * (resp.length / 2).round() + spacing;
      }
    });
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.prestation.numPrestation,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: CustomFutureBuilder(
                future: future,
                progressIndicator: Column(children: [
                  const PortailIndicator(),
                  Text(
                    "Recherche des actions possibles...",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ]),
                errorBuilder: _errorBuilder,
                builder: _actionBuilder),
          ),
        ],
      ),
    );
  }

  Widget _actionBuilder(subcontext, snapshot) {
    var actions = snapshot.data!;
    if (actions.isEmpty) {
      return const Column(
        children: [
          Icon(Icons.cancel, size: 50),
          Text("Aucune action possible")
        ],
      );
    }
    var splitter = MediaQuery.of(context).size.width ~/ widget.tileHeight;
    if (splitter.isOdd) ++splitter;
    crossAxisCellCount(index) {
      if (actions.length.isEven) return splitter ~/ 2;
      return actions.length - 1 == index ? splitter : splitter ~/ 2;
    }

    if (actions.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
            color: lightColorScheme.primaryContainer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionIcon(
                  migaction: actions[0],
                ),
                Text(actions[0].tache),
              ],
            )),
      );
    }

    return StaggeredGrid.count(
      axisDirection: AxisDirection.down,
      crossAxisCount: splitter,
      children: List.generate(
        actions.length,
        (index) => StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount(index),
          mainAxisCellCount: 1,
          child: InkWell(
              onTap: () => goto(actions[index], widget.oauthContext ?? context),
              child: Card(
                  color: lightColorScheme.primaryContainer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ActionIcon(
                        migaction: actions[index],
                      ),
                      Text(actions[index].tache),
                    ],
                  ))),
        ),
      ),
    );
  }

  Widget _errorBuilder(
      BuildContext subcontext, AsyncSnapshot<List<MigAction>> snapshot) {
    Navigator.pop(context, snapshot.error);
    return Container();
  }
}

class ActionIcon extends StatelessWidget {
  final MigAction migaction;
  const ActionIcon({super.key, required this.migaction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 195,
        ),
        Positioned(
          left: 45,
          top: 0,
          child: Icon(
            migaction.type!.icon,
            size: 30,
            color: switch (migaction.type) {
              EnumMigAction.affectation => CustomColors.green,
              EnumMigAction.restitution => CustomColors.red,
              EnumMigAction.echange => CustomColors.yellow,
              null => Colors.transparent
            },
          ),
        ),
        Icon(
          migaction.typeEquipement == "CPE" ? Icons.router : Icons.tv_outlined,
          size: 45,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );
  }
}
