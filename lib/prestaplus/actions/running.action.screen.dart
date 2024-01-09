import 'package:flutter/material.dart';
import 'package:librairies/keycloack_auth.dart';
import 'package:librairies/somethingwentwrong.dart';
import 'package:librairies/streambuilder.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/menu.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/loader.riv.dart';
import 'package:web_socket_channel/io.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/websocket.client.message.dart';
import 'package:portail_canalplustelecom_mobile/dao/websokect.server.message.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class RunningActionScreen extends StatefulWidget {
  final Prestation prestation;
  final MigAction migAction;
  final MigWebSocketClientMessage message;
  const RunningActionScreen({
    super.key,
    required this.prestation,
    required this.migAction,
    required this.message,
  });

  @override
  State<RunningActionScreen> createState() => _RunningActionScreenState();

  Stream<StreamResponse> migStreamWebsocket(BuildContext context) async* {
    final channel = IOWebSocketChannel.connect(
      Uri.parse("wss://re7.oss.canalplustelecom.com/pfs/websocket"),
      //  Uri.parse("wss://${ApplicationConfiguration.instance!.webapipfs}/api/Mig/action-equipement/ws"),
      //  Uri.parse("ws://fr-1vm-crmws13-r7/webApi_PFS/api/Mig/action-equipement/ws"),
      //  Uri.parse("wss://192.168.0.11:5001/websocket/mig/action/equipement"),
      //  Uri.parse("ws://fr-1vm-crmws13-r7/webApi_PFS/websocket/mig/action/equipement"),
      headers: {
        'X-AUTH-TOKEN':
            "Bearer ${OAuthManager.of(context)?.client?.credentials.accessToken}",
        "Upgrade": "websocket",
        "Connection": "Upgrade",
      },
    );
    StreamResponse response = StreamResponse(errors: {}, actions: {});

    channel.sink.add(message.toJson());
    print(message.toJson());
    await for (var msg in channel.stream) {
      var message = MigWebSocketServerMessage.fromJson(msg);
      if (message.migNotifiyPrestationTacheMessage != null) {
        response = response.copyWith(
            prestationTache: message.migNotifiyPrestationTacheMessage);

        print(
            "====> stream message : ${message.migNotifiyPrestationTacheMessage?.statut}");
        print("====> stream response : ${response.prestationTache?.statut}");
      }
      if (message.migNotifiyPrestationTacheActionMessage != null) {
        response.actions[message.migNotifiyPrestationTacheActionMessage!
            .actionid] = message.migNotifiyPrestationTacheActionMessage!;

        print(
            "=======> stream action message :${message.migNotifiyPrestationTacheActionMessage?.actionid} ${message.migNotifiyPrestationTacheActionMessage?.statut}");
        print(
            "=======> stream action response : ${response.actions[message.migNotifiyPrestationTacheActionMessage?.actionid]?.statut}");
      }

      if (message.message.isNotEmpty) {
        response.errors[message.migNotifiyPrestationTacheActionMessage!
            .actionid] = message.message.replaceAll(RegExp(r'"'), "");
      }
      yield response;
    }
  }
}

class _RunningActionScreenState extends State<RunningActionScreen> {
  LoaderController loaderController = LoaderController();
  GlobalKey<ScaffoldMenuState> scafState = GlobalKey();

  Map<int, LoaderController> controllers = {};

  @override
  Widget build(BuildContext context) {
    Widget backButton = FilledButton.icon(
        icon: const Icon(Icons.home),
        onPressed: () => OAuthManager.of(context)?.navigatePushReplacement(
            context, const ScaffoldMenu(selectedmenu: Menu.prestaplus)),
        label: const Text("Retour Accueil"));

    return ScaffoldMenu(
      key: scafState,
      child: EnhancedStreamBuilder<StreamResponse>(
        progressIndicator: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: PortailIndicator(
                width: 100,
                height: 100,
              ),
            ),
            Text("Chargement de l'action en cours...")
          ],
        ),
        error: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SomethingWenWrong(
                iconsize: 50,
                line1: "Erreur de connexion au Websocket",
                line2: "Contactez le support",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: backButton,
              )
            ],
          ),
        ),
        noelement: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SomethingWenWrong(
                iconsize: 50,
                line1: "Erreur websocket pas de données",
                line2: "Contactez le support",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: backButton,
              )
            ],
          ),
        ),
        stream: widget.migStreamWebsocket(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("===========> ${snapshot.data?.prestationTache?.statut}");

            if (snapshot.data?.statut != StreamResponseStatut.ok) {
              loaderController.error();
            }

            snapshot.data?.actions.forEach(
              (key, value) {
                if (controllers.containsKey(key) == false) {
                  controllers[key] = LoaderController();
                }

                if (value.statut.toUpperCase() == "EN COURS") {
                  controllers[key]?.reset();
                }
                if (value.statut.toUpperCase() == "OK") {
                  controllers[key]?.check();
                }
                if (value.statut.toUpperCase() == "KO") {
                  controllers[key]?.error();
                }
              },
            );
          } else {
            if (snapshot.data?.statut == StreamResponseStatut.encours) {
              loaderController.reset();
            }
            if (snapshot.data?.statut == StreamResponseStatut.ok) {
              loaderController.check();
            }
            if (snapshot.data?.statut == StreamResponseStatut.ko) {
              loaderController.error();
            }
          }

          snapshot.data?.actions.forEach(
            (key, value) {
              if (controllers.containsKey(key) == false) {
                controllers[key] = LoaderController();
              }

              if (value.statut.toUpperCase() == "EN COURS") {
                controllers[key]?.reset();
              }
              if (value.statut.toUpperCase() == "OK") {
                controllers[key]?.check();
              }
              if (value.statut.toUpperCase() == "KO") {
                controllers[key]?.error();
              }
            },
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.migAction.tache,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Center(
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child:
                        LoaderIndicator(loadingController: loaderController)),
              ),
              HistoAction(
                onTap: (key) {
                  if (snapshot.data?.errors[key] == null) return;
                  if (snapshot.data!.errors[key]!.isEmpty) return;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Fermer"))
                          ],
                          content: Text(
                            snapshot.data?.errors[key] ?? "{data:null}",
                          ),
                        );
                      });
                },
                actions: snapshot.data!.actions,
                controllers: controllers,
              ),
              Visibility(
                visible: snapshot.connectionState == ConnectionState.done,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: backButton,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class HistoAction extends StatelessWidget {
  final Map<int, LoaderController>? controllers;
  final Function(int key)? onTap;
  const HistoAction({
    super.key,
    required this.actions,
    this.controllers,
    this.onTap,
  });
  final Map<int, MigNotifiyPrestationTacheActionMessage>? actions;

  @override
  Widget build(BuildContext context) {
    List<Widget> pactions = [];

    actions?.forEach(
      (key, value) {
        pactions.add(InkWell(
          onTap: () => onTap?.call(key),
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value.label),
                      Text(
                        value.prestationtacheactionid.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: LoaderIndicator(
                            loadingController: controllers?[key])),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
    return Column(children: pactions);
  }
}

enum StreamResponseStatut {
  ok,
  encours,
  ko,
  uknown;
}

class StreamResponse {
  final String? message;
  final bool error;
  final MigNotifiyPrestationTacheMessage? prestationTache;
  final Map<int, MigNotifiyPrestationTacheActionMessage> actions;
  final Map<int, String> errors;
  StreamResponse({
    this.message,
    this.error = false,
    this.prestationTache,
    required this.actions,
    required this.errors,
  });

  bool get isOk => prestationTache?.statut.toUpperCase() == "OK";
  bool get isEnCours => prestationTache?.statut.toUpperCase() == "EN COURS";
  bool get isKo => prestationTache?.statut.toUpperCase() == "KO";

  StreamResponseStatut get statut {
    if (isOk) return StreamResponseStatut.ok;
    if (isEnCours) return StreamResponseStatut.encours;
    if (isKo) return StreamResponseStatut.ko;
    return StreamResponseStatut.uknown;
  }

  StreamResponse copyWith({
    String? message,
    bool? error,
    MigNotifiyPrestationTacheMessage? prestationTache,
    Map<int, MigNotifiyPrestationTacheActionMessage>? actions,
    Map<int, String>? errors,
  }) {
    return StreamResponse(
      message: message ?? this.message,
      error: error ?? this.error,
      prestationTache: prestationTache ?? this.prestationTache,
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
    );
  }
}
