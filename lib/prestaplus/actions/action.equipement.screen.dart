import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/recherche.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/saisiemanuelle.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/scanner.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/floatingactionbuttonvisible.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/tab.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class RechercheParam {
  static String? param;
}

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
  GlobalKey<FABAnimatedState> floatingActionButtonKey = GlobalKey();
  TabControllerWrapper wrapper = TabControllerWrapper();
  String? param;
  Equipement? equipement;

  @override
  Widget build(BuildContext context) {
    RechercheParam.param = null;
    return ScaffoldTabs(
        tabcontroller: wrapper,
        floatingActionButtonKey: floatingActionButtonKey,
        appBar: AppBar(
          title: Text(widget.migaction.tache),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FilledButton.icon(
            icon: const Icon(Icons.ads_click_sharp),
            onPressed: () => switch (widget.migaction.type!) {
                  EnumMigAction.affectation => affecter(),
                  EnumMigAction.restitution => restituer(),
                  EnumMigAction.echange => echanger(),
                },
            label: Text(widget.migaction.tache)),
        tabs: {
          const HorizontalTab(label: "Scanner", icondata: Icons.qr_code):
              ScannerEquipement(
            prestation: widget.prestation,
            onSelected: (param) {
              wrapper.controller?.animateTo(1);
              RechercheParam.param = param;
            },
          ),
          const HorizontalTab(label: "Rechercher", icondata: Icons.search):
              RechercheEquipement(
            prestation: widget.prestation,
            onSelected: onSelected,
          ),
          const HorizontalTab(
              label: "Saisie manuelle",
              icondata: Icons.draw_outlined): SaisieManuelle(
                onSubmit: (param) {
                onSelected(null, param);
              }, migaction: widget.migaction,),
        }
        );
  }

  onSelected(Equipement? e, String? param) {
    equipement = e;
    param = param;
    if (e == null && param ==null) {
      floatingActionButtonKey.currentState?.hide();
    } else {
      floatingActionButtonKey.currentState?.show();
    }
  }

  Future affecter() {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();

    return actionDialog(
        action: () =>
            Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
                .then((value) => rnd.nextInt(max).isEven));
  }

  Future restituer() async {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();
    return actionDialog(
        action: () =>
            Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
                .then((value) => rnd.nextInt(max).isEven));
  }

  Future echanger() async {
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
                ?.navigatePush(context, const ScaffoldMenu());
          }
        },
      ).show();
    }
  }
}
