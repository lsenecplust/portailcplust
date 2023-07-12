import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class Prestation extends Equatable {
  final String numPrestation;
  final String idRdvPxo;
  final String clientNom;
  final String contactNom;
  final String contactPrenom;
  final String contactEmail;
  final String contactTel;
  final DateTime dateRdv;
  final String offre;
  const Prestation({
    required this.numPrestation,
    required this.idRdvPxo,
    required this.clientNom,
    required this.contactNom,
    required this.contactPrenom,
    required this.contactEmail,
    required this.contactTel,
    required this.dateRdv,
    required this.offre,
  });

  Prestation copyWith({
    String? numPrestation,
    String? idRdvPxo,
    String? clientNom,
    String? contactNom,
    String? contactPrenom,
    String? contactEmail,
    String? contactTel,
    DateTime? dateRdv,
    String? offre,
  }) {
    return Prestation(
      numPrestation: numPrestation ?? this.numPrestation,
      idRdvPxo: idRdvPxo ?? this.idRdvPxo,
      clientNom: clientNom ?? this.clientNom,
      contactNom: contactNom ?? this.contactNom,
      contactPrenom: contactPrenom ?? this.contactPrenom,
      contactEmail: contactEmail ?? this.contactEmail,
      contactTel: contactTel ?? this.contactTel,
      dateRdv: dateRdv ?? this.dateRdv,
      offre: offre ?? this.offre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numPrestation': numPrestation,
      'idRdvPxo': idRdvPxo,
      'clientNom': clientNom,
      'contactNom': contactNom,
      'contactPrenom': contactPrenom,
      'contactEmail': contactEmail,
      'contactTel': contactTel,
      'dateRdv': dateRdv.millisecondsSinceEpoch,
      'offre': offre,
    };
  }

  factory Prestation.fromMap(Map<String, dynamic> map) {
    return Prestation(
      numPrestation: map['numPrestation'] ?? '',
      idRdvPxo: map['idRdvPxo'] ?? '',
      clientNom: map['clientNom'] ?? '',
      contactNom: map['contactNom'] ?? '',
      contactPrenom: map['contactPrenom'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      contactTel: map['contactTel'] ?? '',
      dateRdv: DateTime.parse(map['dateRdv']),
      offre: map['offre'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Prestation.fromJson(String source) =>
      Prestation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Prestation(numPrestation: $numPrestation, idRdvPxo: $idRdvPxo, clientNom: $clientNom, contactNom: $contactNom, contactPrenom: $contactPrenom, contactEmail: $contactEmail, contactTel: $contactTel, dateRdv: $dateRdv, offre: $offre)';
  }

  @override
  List<Object> get props {
    return [
      numPrestation,
      idRdvPxo,
      clientNom,
      contactNom,
      contactPrenom,
      contactEmail,
      contactTel,
      dateRdv,
      offre,
    ];
  }

  String get contactFullname => "$contactNom $contactPrenom";

  /*-----------------------------------------------------------------------------*/
  /*-----------------------------    FETCH METHODS  -----------------------------*/
  /*-----------------------------------------------------------------------------*/

  static Future<List<Prestation>> get(BuildContext context) async {
    try {
      var data = await OAuthManager.of(context)!.get(
          context, "${ApplicationConfiguration.instance!.webapipfs}/pro/list");
      return List.from(data.map((e) => Prestation.fromMap(e)));
    } on NotFound catch (_) {
      return List.empty();
    }
  }

  static Future<List<Prestation>> search(
      BuildContext context, String param) async {
    var data = await OAuthManager.of(context)!.get(context,
        "${ApplicationConfiguration.instance!.webapipfs}/pro/search/$param");
    return List.from(data.map((e) => Prestation.fromMap(e)));
  }

  Future<List<MigAction>> getAllActions(BuildContext context) async {
    var data = await OAuthManager.of(context)!.get(context,
        "${ApplicationConfiguration.instance!.webapipfs}/actions/$numPrestation",
        params: {'prestation': numPrestation, 'offre': offre});

    return List.from(data.map((e) => MigAction.fromMap(e)));
  }

  Future<List<MigAction>> getActions(BuildContext context) async {
    List<MigAction> actions = await getAllActions(context);

    return actions.where((element) => element.isExecutable).toList()
      ..sort((a, b) => a.tache.compareTo(b.tache));
  }

  Future<bool> affecterEquipement(
    BuildContext context, {
    required Equipement equipement,
  }) async {
    var data = await OAuthManager.of(context)!.post(context,
        "${ApplicationConfiguration.instance!.webapipfs}/action/affecter-equipement/$offre/$numPrestation",
        body: equipement.toMap());
    return data;
  }

  Future<bool> restituerEquipement(
    BuildContext context, {
    required Equipement equipement,
  }) async {
    var data = await OAuthManager.of(context)!.post(context,
        "${ApplicationConfiguration.instance!.webapipfs}/action/restituer-equipement/$offre/$numPrestation",
        body: equipement.toMap());
    return data;
  }

  Future<bool> echangerEquipement(
    BuildContext context, {
    required Equipement ancienEquipement,
    required Equipement nouveauEquipement,
    String? ancienNumDec,
  }) async {
    var data = await OAuthManager.of(context)!.post(context,
        "${ApplicationConfiguration.instance!.webapipfs}/action/echanger-equipement/$offre/$numPrestation",
        body: {
          'ancienEquipement': ancienEquipement.toMap(),
          'nouveauEquipement': nouveauEquipement.toMap(),
        });
    return data;
  }
}
