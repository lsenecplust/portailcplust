import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:librairies/streambuilder.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/websokect.server.message.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/recherche.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/saisiemanuelle.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/scanner.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/floatingactionbuttonvisible.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/tab.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  Stream migStreamWebsocket() async* {
    List<MigWebSocketServerMessage> histo = [];
    final channel = IOWebSocketChannel.connect(
        Uri.parse("ws://192.168.0.14/api/Mig/action-equipement/ws/"),
        headers: {
          'Authorization':
              "Bearer ${OAuthManager.of(context)?.client?.credentials.accessToken}"
        });

    channel.sink.add(json.encode({
      "prestationRef": "EPR2391953",
      "CodeTache": "T0013",
      "Offre": "FIBCOFINU",
      "nouvelEquipement": {
        "typeEquipement": "ONT",
        "numDec": "693000043113",
        "adresseMAC": "693000043113",
        "numeroSerie": "693000043113"
      }
    }));

    await for (var msg in channel.stream) {
      histo.add(MigWebSocketServerMessage.fromJson(msg));
      yield histo;
    }

  }

  Future openWebSocketForAction(MigAction action) async {
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: MediaQuery.of(context).size.height * 0.8,
            height: MediaQuery.of(context).size.height * .25,
            child: EnhancedStreamBuilder(
              progressIndicator: const PortailIndicator(),
              stream: migStreamWebsocket(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Future.microtask((() {
                    Navigator.pop(context);
                    resultDialog(true, "Good");
                  }));
                }
                return Center(child: Text(snapshot.data ?? "0"));
              },
            ),
          ),
        );
      },
    );
    return Future.value(null);
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

  void resultDialog(bool retour, String msg) {
    AwesomeDialog(
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
          OAuthManager.of(context)?.navigatePush(context, const ScaffoldMenu());
        }
      },
    ).show();
  }
}
