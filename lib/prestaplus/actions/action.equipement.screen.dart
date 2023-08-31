import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/websocket.client.message.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/recherche.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/running.action.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/saisiemanuelle.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/scanner.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/floatingactionbuttonvisible.widget.dart';
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
  Equipement? newEchangeEquipment;
  Equipement? oldEchangeEquipment;

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
            onPressed: () => openWebSocketForAction(widget.migAction),
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

  onSelected(Equipement? newEq, Equipement? oldEq) {
    newEchangeEquipment = newEq;
    oldEchangeEquipment = oldEq;

    if (showButtonAction) {
      floatingActionButtonKey.currentState?.show();
    } else {
      floatingActionButtonKey.currentState?.hide();
    }
  }

  openWebSocketForAction(MigAction action) {
    if (newEchangeEquipment == null) {
      return errorDialog("Aucun équipement sélectioné");
    }
    if (newEchangeEquipment!.getType == null) {
      return errorDialog("Type équimement introuvable");
    }
    if (action.type == EnumMigAction.echange) {
      if (oldEchangeEquipment == null) {
        return errorDialog("Aucun ancien équipement sélectioné");
      }
      if (oldEchangeEquipment!.getType == null) {
        return errorDialog("Type ancien équimement introuvable");
      }
    }

    OAuthManager.of(context)?.navigatePush(
        context,
        RunningActionScreen(
          prestation: widget.prestation,
          migAction: action,
          message: MigWebSocketClientMessage(
              prestationRef: widget.prestation.numPrestation,
              codeTache: widget.migAction.codeTache,
              offre: widget.prestation.offre,
              nouvelEquipement: newEchangeEquipment,
              ancienEquipement: oldEchangeEquipment),
        ));
  }

  void errorDialog(String msg) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      autoHide: const Duration(seconds: 2),
      dialogType: DialogType.error,
      showCloseIcon: true,
      title: 'Error',
      desc: msg,
      btnOkIcon: Icons.check_circle,
    ).show();
  }
}
