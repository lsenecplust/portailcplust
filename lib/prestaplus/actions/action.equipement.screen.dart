import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/recherche.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/saisiemanuelle.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/scanner.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/floatingactionbuttonvisible.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/tab.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';


class ActionEquipementScreen extends StatefulWidget {
  final Prestation prestation;
  final MigAction migAction;
  const ActionEquipementScreen({
    Key? key,
    required this.prestation,
    required this.migAction,
  }) : super(key: key);

  @override
  State<ActionEquipementScreen> createState() => _ActionEquipementScreenState();
}

class _ActionEquipementScreenState extends State<ActionEquipementScreen> {
  GlobalKey<FABAnimatedState> floatingActionButtonKey = GlobalKey();
  EquipementQuery? newEchangeEquipment;
  EquipementQuery? oldEchangeEquipment;

  @override
  Widget build(BuildContext context) {
    return ScaffoldTabs(
        floatingActionButtonKey: floatingActionButtonKey,
        appBar: AppBar(
          title: Text(widget.migAction.tache),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FilledButton.icon(
            icon: const Icon(Icons.ads_click_sharp),
            onPressed: () => switch (widget.migAction.type!) {
                  EnumMigAction.affectation => affecter(),
                  EnumMigAction.restitution => restituer(),
                  EnumMigAction.echange => echanger(),
                },
            label: Text(widget.migAction.tache)),
        tabs: {
          const HorizontalTab(label: "Scanner", icondata: Icons.qr_code):
              ScannerEquipement(
            prestation: widget.prestation,
            onSubmit: onSelected,
            migAction: widget.migAction,
          ),
          const HorizontalTab(label: "Rechercher", icondata: Icons.search):
              RechercheManuelle(
            migaction: widget.migAction,
            prestation: widget.prestation,
            onSubmit: onSelected,
          ),
          const HorizontalTab(
              label: "Saisie manuelle",
              icondata: Icons.draw_outlined): SaisieManuelle(
            onSubmit: onSelected,
            migaction: widget.migAction,
          ),
        });
  }

  bool get showButtonAction {
    if (widget.migAction.type == EnumMigAction.echange) {
      return newEchangeEquipment != null && oldEchangeEquipment != null;
    }
    return newEchangeEquipment != null;
  }

  onSelected(EquipementQuery? newEq, EquipementQuery? oldEq) {
    newEchangeEquipment = newEq;
    oldEchangeEquipment = oldEq;

    if (showButtonAction) {
      floatingActionButtonKey.currentState?.show();
    } else {
      floatingActionButtonKey.currentState?.hide();
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
        desc: '${widget.migAction.tache} Terminéee',
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
