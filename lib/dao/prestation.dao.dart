import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/httperrorhandler.dart';

class Prestation extends Equatable {
  final String idPrestation;
  final DateTime daterendezvous;
  final String client;
  final String adresse;
  final int codepostale;
  final String ville;
  const Prestation({
    required this.idPrestation,
    required this.daterendezvous,
    required this.client,
    required this.adresse,
    required this.codepostale,
    required this.ville,
  });

  Prestation copyWith({
    String? idPrestation,
    DateTime? daterendezvous,
    String? client,
    String? adresse,
    int? codepostale,
    String? ville,
  }) {
    return Prestation(
      idPrestation: idPrestation ?? this.idPrestation,
      daterendezvous: daterendezvous ?? this.daterendezvous,
      client: client ?? this.client,
      adresse: adresse ?? this.adresse,
      codepostale: codepostale ?? this.codepostale,
      ville: ville ?? this.ville,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPrestation': idPrestation,
      'daterendezvous': daterendezvous.millisecondsSinceEpoch,
      'client': client,
      'adresse': adresse,
      'codepostale': codepostale,
      'ville': ville,
    };
  }

  factory Prestation.fromMap(Map<String, dynamic> map) {
    return Prestation(
      idPrestation: map['idPrestation'] ?? '',
      daterendezvous: DateFormat("d/M/y").parse(map['daterendezvous']),
      client: map['client'] ?? '',
      adresse: map['adresse'] ?? '',
      codepostale: map['codepostale']?.toInt() ?? 0,
      ville: map['ville'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Prestation.fromJson(String source) =>
      Prestation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Prestation(idPrestation: $idPrestation, daterendezvous: $daterendezvous, client: $client, adresse: $adresse, codepostale: $codepostale, ville: $ville)';
  }

  @override
  List<Object> get props {
    return [
      idPrestation,
      daterendezvous,
      client,
      adresse,
      codepostale,
      ville,
    ];
  }

  /*-----------------------------------------------------------------------------*/
  /*-----------------------------    FETCH METHODS  -----------------------------*/
  /*-----------------------------------------------------------------------------*/

  static Future<List<Prestation>> get get async {
    var response = await http.get(
        Uri.parse('https://mocki.io/v1/997242b9-7984-4f2e-b267-660a8ef91040'));
    HttpErrorHandler.handle(response);
    var data = jsonDecode(response.body);
    return List.from(data.map((e) => Prestation.fromMap(e)));
  }

}
