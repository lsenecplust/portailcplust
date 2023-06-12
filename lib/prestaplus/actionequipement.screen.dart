import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/affecterrestituer.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';

class ActionEquipementScreen extends StatefulWidget {
  final Prestation prestation;
  final MigAction migaction;
  const ActionEquipementScreen({
    Key? key,
    required this.prestation,
    required this.migaction,
  }) : super(key: key);

  @override
  State<ActionEquipementScreen> createState() => _ActionEquipementScreenState();
}

class _ActionEquipementScreenState extends State<ActionEquipementScreen> {
  GlobalKey<RootContainerState> rootContainerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RootContainer(
      key: rootContainerKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.icon(
            icon: const Icon(Icons.ads_click_sharp),
            onPressed: () => switch (widget.migaction.type!) {
                  EnumMigAction.affectation => test(),
                  EnumMigAction.restitution => test(),
                  EnumMigAction.echange => test(),
                },
            label:
                Text(widget.migaction.tache)),
      title: widget.migaction.tache,
      child: switch (widget.migaction.type!) {
        (EnumMigAction.affectation) => AffecterRestituer(
            onSelected: onSelected,
            prestation: widget.prestation,
            migaction: widget.migaction),
        (EnumMigAction.restitution) => AffecterRestituer(
            onSelected: onSelected,
            prestation: widget.prestation,
            migaction: widget.migaction),
        (EnumMigAction.echange) =>
          Echange(prestation: widget.prestation, migaction: widget.migaction)
      },
    );
  }

  void test() {

  }

  onSelected(Equipement? e, String? param) {
    rootContainerKey.currentState?.toggleFloatingActionButton();
  }

  Future affecter(Equipement? e, String? param) {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();

    return actionDialog(
        action: () =>
            Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
                .then((value) => rnd.nextInt(max).isEven));
  }

  Future restituer(Equipement? e, String? param) async {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();
    return actionDialog(
        action: () =>
            Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
                .then((value) => rnd.nextInt(max).isEven));
  }

  Future echanger(Equipement? e, String? param) async {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();
    return actionDialog(
        action: () =>
            Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
                .then((value) => rnd.nextInt(max).isEven));
  }

  Future actionDialog({required Future<bool> Function() action}) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: PortailIndicator(),
        );
      },
    );
    var actionok = await action();
    if (mounted) {
      Navigator.pop(context);
      await AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        autoHide: const Duration(seconds: 2),
        dialogType: actionok ? DialogType.success : DialogType.error,
        showCloseIcon: true,
        title: actionok ? 'Succes' : 'Error',
        desc: '${widget.migaction.tache} Terminéee',
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          if (actionok) {
            OAuthManager.of(context)
                ?.navigatePush(context, const RootContainer());
          }
        },
      ).show();
    }
  }
}
