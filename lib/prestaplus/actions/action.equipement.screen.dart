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

  onSelected(Equipement? newEq, Equipement? oldEq) {
    newEchangeEquipment = newEq;
    oldEchangeEquipment = oldEq;

    if (showButtonAction) {
      floatingActionButtonKey.currentState?.show();
    } else {
      floatingActionButtonKey.currentState?.hide();
    }
  }

  Future affecter() async {
    try {
      if (newEchangeEquipment == null) {
        return errorDialog("Aucun équipement sélectioné");
      }
      if (newEchangeEquipment!.getType == null) {
        return errorDialog("Type équimement introuvable");
      }
      var res = await widget.prestation
          .affecterEquipement(context, equipement: newEchangeEquipment!);
      return actionDialog(retour: res);
    } catch (e) {
      return errorDialog("Erreur API : 0x987415");
    }
  }

  Future restituer() async {
    if (newEchangeEquipment == null) {
      return errorDialog("Aucun équipement sélectioné");
    }
    if (newEchangeEquipment!.getType == null) {
      return errorDialog("Type équimement introuvable");
    }
    var res = await widget.prestation
        .restituerEquipement(context, equipement: newEchangeEquipment!);
    return actionDialog(retour: res);
  }

  Future echanger() async {
    //TODO ########## set erreur if codeOffre vide
    if (newEchangeEquipment == null) {
      return errorDialog("Aucun nouvel équipement sélectioné");
    }

    if (oldEchangeEquipment == null) {
      return errorDialog("Aucun ancien équipement sélectioné");
    }
    if (newEchangeEquipment!.getType == null) {
      return errorDialog("Type nouvel équimement introuvable");
    }
    if (oldEchangeEquipment!.getType == null) {
      return errorDialog("Type ancien équimement introuvable");
    }

    var res = await widget.prestation.echangerEquipement(context,
        nouveauEquipement: newEchangeEquipment!,
        ancienEquipement: oldEchangeEquipment!);
    return actionDialog(retour: res);
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

  Future actionDialog({required bool retour}) async {
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

    if (mounted) {
      Navigator.pop(context);
      await AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        autoHide: const Duration(seconds: 2),
        dialogType: retour ? DialogType.success : DialogType.error,
        showCloseIcon: true,
        title: retour ? 'Succes' : 'Error',
        desc: '${widget.migAction.tache} Terminée',
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          if (retour) {
            OAuthManager.of(context)
                ?.navigatePush(context, const ScaffoldMenu());
          }
        },
      ).show();
    }
  }
}
