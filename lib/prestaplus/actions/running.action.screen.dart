import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:librairies/keycloack_auth.dart';
import 'package:librairies/somethingwentwrong.dart';
import 'package:librairies/streambuilder.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestationtache.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestationtacheaction.dao.dart';
import 'package:portail_canalplustelecom_mobile/menu.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/loader.riv.dart';
import 'package:portail_canalplustelecom_mobile/widgets/toggle.buttons.widget.dart';
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
/*
  Stream migStreamWebsocketMocked(BuildContext context) async* {
    for (var element in [
      {
        "type": "WsProcessAlreadyRunning",
        "data": {
          "prestationTache": {
            "Id": 180540,
            "TacheId": 82,
            "PrestationId": 21320,
            "DateDebut": "2024-01-09T16:37:02.356894",
            "DateFin": "2024-01-09T16:38:01.760378",
            "Operateur": "PFS",
            "Detail":
                "regie/notifier_alerte : action en cours d'exécution\nmig/valider_logistique : Equipement non-referencable données manquante: new=8685860585\nvalider_logistique : erreur pendant l'exécution de l'action\nOk : 1\nKO : 1",
            "Context": null,
            "ContextJson":
                "{\"actions_executees\":[{\"id\":326,\"tache_id\":82,\"service_id\":19,\"priorite\":0,\"handler\":\"regie\\/notifier_alerte\",\"activer_log\":\"oui\",\"options\":null,\"step\":0,\"service_url\":\"tcp:\\/\\/10.105.20.198:61613\",\"service_statut\":null,\"basedir\":\"regie\",\"protocole_id\":21,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"en cours\",\"detail\":\"\"},{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"mig\\/valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"ko\",\"detail\":\"Equipement non-referencable donn\\u00e9es manquante: new=8685860585\"},{\"id\":326,\"tache_id\":82,\"service_id\":19,\"priorite\":0,\"handler\":\"regie\\/notifier_alerte\",\"activer_log\":\"oui\",\"options\":null,\"step\":1,\"service_url\":\"tcp:\\/\\/10.105.20.198:61613\",\"service_statut\":null,\"basedir\":\"regie\",\"protocole_id\":21,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314789,\"action_statut\":\"en cours\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":{\"message\":{\"from\":\"MIG\",\"to\":\"REGIE\",\"dateT\":\"2024-01-09 16:38:01\",\"action\":\"createAlerte\",\"record\":{\"reference_prestation\":\"EPR2372575\",\"operateur\":\"PFS\",\"tache_id\":82,\"tache_status\":\"ko\",\"tache_label\":\"Gestion Ressources Equipement Echange ONT\",\"handler\":\"echanger_ont\",\"tache_code\":\"T0011\",\"details\":\"regie\\/notifier_alerte : action en cours d'ex\\u00e9cution\\nmig\\/valider_logistique : Equipement non-referencable donn\\u00e9es manquante: new=8685860585\",\"action_tache_id\":82,\"prestation_tache_id\":180540,\"prestation_tache_action_id\":314790}},\"queue\":\"NOTIFICATION_ALERTE\"},\"output\":{\"resultat du send\":\"ID:fr-1vm-b2bamq01-r7.infra.msv-45900-1699283087073-3:106946\"},\"statut\":\"ok\",\"detail\":\"\"},{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314790,\"action_statut\":\"ko\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"ko\"}],\"actions_restantes\":[{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314790,\"action_statut\":\"ko\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"output\":\"\\\"\\\"\"},{\"id\":296,\"tache_id\":82,\"service_id\":15,\"priorite\":2,\"handler\":\"bad-delete-appairage-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":297,\"tache_id\":82,\"service_id\":15,\"priorite\":3,\"handler\":\"inventaire-desaffectation-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":298,\"tache_id\":82,\"service_id\":15,\"priorite\":4,\"handler\":\"inventaire-affectation-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":299,\"tache_id\":82,\"service_id\":15,\"priorite\":5,\"handler\":\"bad-post-appairage-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null}]}",
            "Input":
                "{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}}",
            "Output": "Array",
            "Statut": "ko",
            "Log": null
          }
        }
      },
      {
        "type": "PrestationTacheMessage",
        "data": {
          "action": "INSERT",
          "statut": null,
          "tacheId": 82,
          "prestationTacheId": 180539,
          "prestationId": 21320
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 335,
          "label": "Another One",
          "prestationTacheActionId": 314787,
          "statut": "en cours",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 326,
          "label": "Envoi alerte à REGIE +",
          "prestationTacheActionId": 314787,
          "statut": "en cours",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "UPDATE",
          "actionId": 326,
          "label": "Envoi alerte à REGIE +",
          "prestationTacheActionId": 314787,
          "statut": "en cours",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "UPDATE",
          "actionId": 326,
          "label": "Envoi alerte à REGIE +",
          "prestationTacheActionId": 314787,
          "statut": "ok",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheMessage",
        "data": {
          "action": "INSERT",
          "statut": "en cours",
          "tacheId": 82,
          "prestationTacheId": 180539,
          "prestationId": 21320
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 335,
          "label": "Another One",
          "prestationTacheActionId": 314787,
          "statut": "ko",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheAction",
        "data": {
          "Id": 314790,
          "ActionId": 335,
          "PrestationTacheId": 180540,
          "DateDebut": "2024-01-09T16:37:02.496565",
          "DateFin": "2024-01-09T16:37:02.53082",
          "Operateur": "PFS",
          "Detail":
              "Equipement non-referencable données manquante: new=8685860585",
          "Input":
              "{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}}",
          "Output": "\"\"",
          "Statut": "ko",
          "Log": "\n",
          "Action": null,
          "PrestationTache": null,
          "PrestationTacheActionEquipements": []
        }
      },
      {
        "type": "PrestationTacheMessage",
        "data": {
          "action": "INSERT",
          "statut": "ko",
          "tacheId": 82,
          "prestationTacheId": 180539,
          "prestationId": 21320
        }
      },
      {
        "type": "PrestationTache",
        "data": {
          "Id": 180540,
          "TacheId": 82,
          "PrestationId": 21320,
          "DateDebut": "2024-01-09T16:37:02.356894",
          "DateFin": "2024-01-09T16:38:01.760378",
          "Operateur": "PFS",
          "Detail":
              "regie/notifier_alerte : action en cours d'exécution\nmig/valider_logistique : Equipement non-referencable données manquante: new=8685860585\nvalider_logistique : erreur pendant l'exécution de l'action\nOk : 1\nKO : 1",
          "Context": null,
          "ContextJson":
              "{\"actions_executees\":[{\"id\":326,\"tache_id\":82,\"service_id\":19,\"priorite\":0,\"handler\":\"regie\\/notifier_alerte\",\"activer_log\":\"oui\",\"options\":null,\"step\":0,\"service_url\":\"tcp:\\/\\/10.105.20.198:61613\",\"service_statut\":null,\"basedir\":\"regie\",\"protocole_id\":21,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"en cours\",\"detail\":\"\"},{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"mig\\/valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"ko\",\"detail\":\"Equipement non-referencable donn\\u00e9es manquante: new=8685860585\"},{\"id\":326,\"tache_id\":82,\"service_id\":19,\"priorite\":0,\"handler\":\"regie\\/notifier_alerte\",\"activer_log\":\"oui\",\"options\":null,\"step\":1,\"service_url\":\"tcp:\\/\\/10.105.20.198:61613\",\"service_statut\":null,\"basedir\":\"regie\",\"protocole_id\":21,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314789,\"action_statut\":\"en cours\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":{\"message\":{\"from\":\"MIG\",\"to\":\"REGIE\",\"dateT\":\"2024-01-09 16:38:01\",\"action\":\"createAlerte\",\"record\":{\"reference_prestation\":\"EPR2372575\",\"operateur\":\"PFS\",\"tache_id\":82,\"tache_status\":\"ko\",\"tache_label\":\"Gestion Ressources Equipement Echange ONT\",\"handler\":\"echanger_ont\",\"tache_code\":\"T0011\",\"details\":\"regie\\/notifier_alerte : action en cours d'ex\\u00e9cution\\nmig\\/valider_logistique : Equipement non-referencable donn\\u00e9es manquante: new=8685860585\",\"action_tache_id\":82,\"prestation_tache_id\":180540,\"prestation_tache_action_id\":314790}},\"queue\":\"NOTIFICATION_ALERTE\"},\"output\":{\"resultat du send\":\"ID:fr-1vm-b2bamq01-r7.infra.msv-45900-1699283087073-3:106946\"},\"statut\":\"ok\",\"detail\":\"\"},{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314790,\"action_statut\":\"ko\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}},\"output\":\"\",\"statut\":\"ko\"}],\"actions_restantes\":[{\"id\":295,\"tache_id\":82,\"service_id\":1,\"priorite\":1,\"handler\":\"valider_logistique\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"postgresql:\\/\\/mig_ws_soap@localhost:5432\\/mig\",\"service_statut\":null,\"basedir\":\"mig\",\"protocole_id\":1,\"prestation_tache_input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"prestation_tache_action_id\":314790,\"action_statut\":\"ko\",\"prestation_tache_id\":180540,\"prestation_id\":21320,\"input\":\"{\\\"context\\\":{\\\"code_offre\\\":\\\"FIBCOFI\\\",\\\"operateur\\\":\\\"PFS\\\"},\\\"reference_prestation\\\":\\\"EPR2372575\\\",\\\"equipement_ancien\\\":{\\\"numdec\\\":\\\"868685868\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":null,\\\"numero_serie\\\":null,\\\"operateur\\\":\\\"\\\"},\\\"equipement_nouveau\\\":{\\\"numdec\\\":\\\"8685860585\\\",\\\"type\\\":\\\"ONT\\\",\\\"code_ean\\\":null,\\\"adresse_mac\\\":\\\"\\\",\\\"numero_serie\\\":\\\"\\\",\\\"operateur\\\":\\\"\\\"}}\",\"output\":\"\\\"\\\"\"},{\"id\":296,\"tache_id\":82,\"service_id\":15,\"priorite\":2,\"handler\":\"bad-delete-appairage-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":297,\"tache_id\":82,\"service_id\":15,\"priorite\":3,\"handler\":\"inventaire-desaffectation-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":298,\"tache_id\":82,\"service_id\":15,\"priorite\":4,\"handler\":\"inventaire-affectation-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null},{\"id\":299,\"tache_id\":82,\"service_id\":15,\"priorite\":5,\"handler\":\"bad-post-appairage-ont\",\"activer_log\":\"oui\",\"options\":\"bloquante\",\"step\":0,\"service_url\":\"{\\\"url\\\":\\\"https:\\/\\/re7.oss.canalplustelecom.com\\\",\\\"keycloak_uri\\\":\\\"\\/dev\\/auth\\/realms\\/OSS-RECETTE\\/protocol\\/openid-connect\\/token\\\",\\\"client_id\\\":\\\"mig\\\",\\\"client_secret\\\":\\\"4c65b961-ab1d-4153-9054-70d8ef11d891\\\",\\\"grant_type\\\":\\\"client_credentials\\\"}\",\"service_statut\":null,\"basedir\":\"stic\",\"protocole_id\":18,\"prestation_tache_action_id\":null,\"action_statut\":null,\"prestation_tache_id\":null,\"prestation_id\":null,\"input\":null,\"output\":null}]}",
          "Input":
              "{\"context\":{\"code_offre\":\"FIBCOFI\",\"operateur\":\"PFS\"},\"reference_prestation\":\"EPR2372575\",\"equipement_ancien\":{\"numdec\":\"868685868\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":null,\"numero_serie\":null,\"operateur\":\"\"},\"equipement_nouveau\":{\"numdec\":\"8685860585\",\"type\":\"ONT\",\"code_ean\":null,\"adresse_mac\":\"\",\"numero_serie\":\"\",\"operateur\":\"\"}}",
          "Output": "Array",
          "Statut": "ko",
          "Log": null
        }
      },
      {
        "type": "WsError",
        "data": {
          "message": "Data is not correct",
        }
      },
      {
        "type": "PrestationTacheMessage",
        "data": {
          "action": "INSERT",
          "statut": "ok",
          "tacheId": 82,
          "prestationTacheId": 180539,
          "prestationId": 21320
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 335,
          "label": "Another One",
          "prestationTacheActionId": 314787,
          "statut": "ok",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 330,
          "label": "Another One 2",
          "prestationTacheActionId": 314787,
          "statut": "en cours",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 330,
          "label": "Another One",
          "prestationTacheActionId": 314787,
          "statut": "en cours",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
      {
        "type": "PrestationTacheActionMessage",
        "data": {
          "action": "INSERT",
          "actionId": 330,
          "label": "Another One",
          "prestationTacheActionId": 314787,
          "statut": "ko",
          "prestationId": 21320,
          "prestationTacheId": 180539
        }
      },
    ]) {
      //await Future.delayed(Durations.short2);
      //await Future.delayed(Durations.extralong3);
      yield json.encode(element);
    }
  }
*/
}

class _RunningActionScreenState extends State<RunningActionScreen> {
  LoaderController loaderController = LoaderController();
  GlobalKey<ScaffoldMenuState> scafState = GlobalKey();

  PrestationTacheMessage? prestationTacheMessage;
  Map<int, PrestationTacheActionMessage> actions = {};
  Map<int, LoaderController> controllers = {};
  Map<int, Map<String, String>> errors = {};
  Map<String, Map<String, String>> prestationError = {};

  Stream wsConnect(Uri uri, String token) {
    final channel = IOWebSocketChannel.connect(
      uri,
      headers: {
        'X-AUTH-TOKEN': token,
        "Upgrade": "websocket",
        "Connection": "Upgrade",
      },
      /*  connectTimeout: const Duration(minutes: 100),
        pingInterval: const Duration(seconds: 20)*/
    );
    // print(message.toJson());
    channel.sink.add(widget.message.toJson());
    return channel.stream;
  }

  Stream migStreamWebsocket(Uri uri, String token) async* {
    bool first = true;
    //await for (var msg in migStreamWebsocketMocked(context)) {
    await for (var msg in wsConnect(uri, token)) {
      if (!first) {
        await Future.delayed(Durations.long2);
        //Delay des message sinon ils arrivent trop vite pour le builder ! il faudrait un stream qui construit l'objet global surment !
      }
      yield msg;
      first = false;
    }
  }


  String get token =>
      "Bearer ${OAuthManager.of(context)?.client?.credentials.accessToken}";
  Uri get wsUrire7 =>
      Uri.parse("wss://re7.oss.canalplustelecom.com/pfs/websocket");
  Uri get wsUri => Uri.parse(
      "wss://${Uri.parse(ApplicationConfiguration.instance!.webapipfs).host}/pfs/websocket");
  @override
  Widget build(BuildContext context) {
    Widget backButton = FilledButton.icon(
        icon: const Icon(Icons.home),
        onPressed: () => OAuthManager.of(context)?.navigatePushReplacement(
            context, const ScaffoldMenu(selectedmenu: Menu.prestaplus)),
        label: const Text("Retour Accueil"));

    handlePrestationTacheMessage(PrestationTacheMessage msg) {
      prestationTacheMessage = msg;
      if (msg.statut.toUpperCase() == "EN COURS") {
        return loaderController.reset();
      }
      if (msg.statut.toUpperCase() == "OK") {
        return loaderController.check();
      }
      if (msg.statut.toUpperCase() == "KO") {
        return loaderController.error();
      }
      return loaderController.error();
    }

    handlePrestationTacheActionMessage(PrestationTacheActionMessage msg) {
      actions[msg.actionId] = msg;
      if (controllers.containsKey(msg.actionId) == false) {
        controllers[msg.actionId] = LoaderController();
      }

      if (msg.statut.toUpperCase() == "EN COURS") {
        return controllers[msg.actionId]?.reset();
      }
      if (msg.statut.toUpperCase() == "OK") {
        return controllers[msg.actionId]?.check();
      }
      if (msg.statut.toUpperCase() == "KO") {
        return controllers[msg.actionId]?.error();
      }
      return controllers[msg.actionId]?.error();
    }

    handlePrestationTacheAction(PrestationTacheAction msg) {
      Map<String, String> error = {};

      try {
        var jsonMap = json.decode(msg.Detail);
        error["detail"] = jsonMap;
      } catch (e) {
        error["detail"] = msg.Detail;
      }

      try {
        var jsonMap = json.decode(msg.Input);
        error["Input"] = jsonMap;
      } catch (e) {
        error["Input"] = msg.Input;
      }

      try {
        var jsonMap = json.decode(msg.Output);
        error["Output"] = jsonMap;
      } catch (e) {
        error["Output"] = msg.Output;
      }

      errors[msg.ActionId] = error;
    }

    handleWsError(WsError msg) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'WsError',
          message: msg.message,
          contentType: ContentType.failure,
        ),
      );

      Future.microtask(() => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar));
    }

    handleWsProcessAlreadyRunning(WsProcessAlreadyRunning msg) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Already Running',
          message:
              "Récuperation du process : ${msg.prestationTache.PrestationId}",
          contentType: ContentType.help,
        ),
      );

      Future.microtask(() => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar));
    }

    handlePrestationTache(PrestationTache msg) {
      try {
        var jsonMap = json.decode(msg.Detail);
        prestationError["Detail"] = jsonMap;
      } catch (e) {
        prestationError["Detail"] = {'Detail': msg.Detail};
      }

      try {
        var jsonMap = json.decode(msg.Input);
        prestationError["Input"] = jsonMap;
      } catch (e) {
        prestationError["Input"] = {"Input": msg.Input};
      }

      try {
        var jsonMap = json.decode(msg.Output);
        prestationError["Output"] = jsonMap;
      } catch (e) {
        prestationError["Output"] = {"Output": msg.Output};
      }

      try {
        var jsonMap = json.decode(msg.ContextJson);
        prestationError["Context"] = jsonMap;
      } catch (e) {
        prestationError["Context"] = {"Context": msg.ContextJson};
      }
    }

    return ScaffoldMenu(
      key: scafState,
      child: EnhancedStreamBuilder(
        stream: migStreamWebsocket(wsUri, token),
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
        builder: (context, snapshot) {
          var msg = snapshot.data!;
          var msgHandler = ServerMessageHandler(msg);
          msgHandler.handlemessage(
              prestationTacheMessage: handlePrestationTacheMessage,
              prestationTacheActionMessage: handlePrestationTacheActionMessage,
              prestationTacheAction: handlePrestationTacheAction,
              wsError: handleWsError,
              wsProcessAlreadyRunning: handleWsProcessAlreadyRunning,
              prestationTache: handlePrestationTache);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.migAction.tache,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Prestation : ${prestationTacheMessage?.prestationId}",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Prestation Tache : ${prestationTacheMessage?.prestationTacheId}",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Statut : ${prestationTacheMessage?.statut}",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child:
                          LoaderIndicator(loadingController: loaderController)),
                ),
                AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: PrestationTacheErrorView(prestationError),
                    crossFadeState: prestationError.isEmpty
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Durations.medium1),
                HistoAction(
                  onTap: (key) {
                    if (errors[key] == null) return;
                    if (errors[key]!.isEmpty) return;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Fermer"))
                            ],
                            content: MapView(errors[key]!),
                          );
                        });
                  },
                  actions: actions,
                  controllers: controllers,
                ),
                Visibility(
                  visible: prestationTacheMessage?.statut.isEmpty == false &&
                      prestationTacheMessage?.statut.toUpperCase() !=
                          "EN COURS",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: backButton,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PrestationTacheErrorView extends StatefulWidget {
  final Map<String, dynamic> errors;
  const PrestationTacheErrorView(this.errors, {super.key});

  @override
  State<PrestationTacheErrorView> createState() =>
      _PrestationTacheErrorViewState();
}

class _PrestationTacheErrorViewState extends State<PrestationTacheErrorView> {
  late Widget content = widget.errors.isNotEmpty
      ? MapView(widget.errors.values.first)
      : Container();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Réumé des erreurs"),
      children: [
        Transform.scale(
          scale: 0.95,
          child: ToogleButtons(
            buttons: [...widget.errors.keys.map((e) => ToogleButton(text: e))],
            onSelectIndexChanged: (selectedindex) {
              setState(() {
                content = MapView(widget.errors.values.toList()[selectedindex]);
              });
            },
          ),
        ),
        AnimatedSwitcher(
          duration: Durations.medium1,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: content),
        )
      ],
    );
  }
}

class MapView extends StatelessWidget {
  final Map<String, dynamic> errors;
  const MapView(this.errors, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...errors.entries.map((e) {
          return RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "${e.key} : ",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: e.value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ]));
        })
      ],
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
  final Map<int, PrestationTacheActionMessage>? actions;

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
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "id : ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: value.prestationTacheActionId.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "statut : ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: value.statut,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ])),
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
