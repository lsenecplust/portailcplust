import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/constante.dart';
import 'package:portail_canalplustelecom_mobile/class/http.dart';

class Prestation extends Equatable {
  final String numPrestation;
  final String idRdvPxo;
  final String clientNom;
  final String contactNom;
  final String contactPrenom;
  final String contactEmail;
  final String contactTel;
  final DateTime dateRdv;
  const Prestation({
    required this.numPrestation,
    required this.idRdvPxo,
    required this.clientNom,
    required this.contactNom,
    required this.contactPrenom,
    required this.contactEmail,
    required this.contactTel,
    required this.dateRdv,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Prestation.fromJson(String source) =>
      Prestation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Prestation(numPrestation: $numPrestation, idRdvPxo: $idRdvPxo, clientNom: $clientNom, contactNom: $contactNom, contactPrenom: $contactPrenom, contactEmail: $contactEmail, contactTel: $contactTel, dateRdv: $dateRdv)';
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
    ];
  }

  String get contactFullname => "$contactNom $contactPrenom";

  /*-----------------------------------------------------------------------------*/
  /*-----------------------------    FETCH METHODS  -----------------------------*/
  /*-----------------------------------------------------------------------------*/

  static Future<List<Prestation>> get(BuildContext context) async {
    var data =
        await Http.instance.get(context, "${Constantes.webApihost}/pro/list");
    return List.from(data.map((e) => Prestation.fromMap(e)));
  }
}
