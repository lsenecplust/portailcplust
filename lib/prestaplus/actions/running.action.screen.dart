import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:librairies/streambuilder.dart';
import 'package:timelines/timelines.dart';
import 'package:web_socket_channel/io.dart';

import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/websocket.client.message.dart';
import 'package:portail_canalplustelecom_mobile/dao/websokect.server.message.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class RunningActionScreen extends StatelessWidget {
  final Prestation prestation;
  final MigAction migAction;
  final MigWebSocketClientMessage message;
  const RunningActionScreen({
    Key? key,
    required this.prestation,
    required this.migAction,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<MigWebSocketServerMessage>> migStreamWebsocket() async* {
      List<MigWebSocketServerMessage> histo = [];
      final channel = IOWebSocketChannel.connect(
        Uri.parse("wss://192.168.0.14:5001/api/Mig/action-equipement/ws"),
        headers: {
          'Authorization':
              'Bearer ${OAuthManager.of(context)?.client?.credentials.accessToken}'
        },
      );

      channel.sink.add(message.toJson());

      await for (var msg in channel.stream) {
        histo.add(MigWebSocketServerMessage.fromJson(msg));
        yield histo;
      }
    }

    return ScaffoldMenu(
      child: EnhancedStreamBuilder<List<MigWebSocketServerMessage>>(
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
        stream: migStreamWebsocket(),
        builder: (context, snapshot) {
          bool isDone = snapshot.connectionState == ConnectionState.done;
          bool isError = snapshot.data!.last.error;
          return Column(
            children: [
              Builder(builder: (context) {
                if (isDone) {
                  return isError ? errorWidget : sucessWidget;
                }
                return const Expanded(child: Processindicator());
              }),
              Text(
                "${migAction.tache} ${isDone ? isError ? 'Echec' : 'OK' : 'en cours de traitement'}",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Expanded(child: HistoAction(actions: snapshot.data!)),
            ],
          );
        },
      ),
    );
  }
}

Widget sucessWidget = const Padding(
  padding: EdgeInsets.all(20.0),
  child: CircleAvatar(
    radius: 100,
    backgroundColor: Colors.greenAccent,
    foregroundColor: Colors.white,
    child: Icon(
      Icons.check,
      size: 200,
      color: Colors.white,
    ),
  ),
);

Widget errorWidget = const Padding(
  padding: EdgeInsets.all(20.0),
  child: Icon(
    Icons.cancel,
    size: 200,
    color: Colors.redAccent,
  ),
);

class HistoAction extends StatelessWidget {
  const HistoAction({
    Key? key,
    required this.actions,
  }) : super(key: key);
  final List<MigWebSocketServerMessage> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          connectorTheme: const ConnectorThemeData(
            thickness: 3.0,
            color: Color(0xffd3d3d3),
          ),
          indicatorTheme: const IndicatorThemeData(
            size: 15.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectorBuilder: (_, index, __) =>
              const SolidLineConnector(color: Color(0xff6ad192)),
          indicatorBuilder: (context, index) => const DotIndicator(
            color: Color(0xff6ad192),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            ),
          ),
          contentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(actions[index].message),
          ),
          itemCount: actions.length,
        ),
      ),
    );
  }
}
