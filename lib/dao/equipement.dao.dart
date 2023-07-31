// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';

class Equipement {
  final int? id;
  final String? typeEquipement;
  final String? nomFournisseur;
  final String? referenceProduit;
  final String? typeProduit;
  final String? referenceCommerciale;
  final String? numeroCommande;
  final String? dateCommande;
  final String? dateProductionUsine;
  final String? lotProduction;
  final String? numeroSerie;
  final String? codeEAN;
  final String? adresseMAC;
  final String? versionHardware;
  final String? versionFirmware;
  final String? motdepasseFTP;
  final String? motdepasseAdmin;
  final int? supportWIFI;
  final String? ssid;
  final String? cleWEP;
  final String? typeADSL;
  final String? numdec;
  final String? marque;
  Equipement({
    this.id,
    this.typeEquipement,
    this.nomFournisseur,
    this.referenceProduit,
    this.typeProduit,
    this.referenceCommerciale,
    this.numeroCommande,
    this.dateCommande,
    this.dateProductionUsine,
    this.lotProduction,
    this.numeroSerie,
    this.codeEAN,
    this.adresseMAC,
    this.versionHardware,
    this.versionFirmware,
    this.motdepasseFTP,
    this.motdepasseAdmin,
    this.supportWIFI,
    this.ssid,
    this.cleWEP,
    this.typeADSL,
    this.numdec,
    this.marque,
  });

  Equipement copyWith({
    int? id,
    String? typeEquipement,
    String? nomFournisseur,
    String? referenceProduit,
    String? typeProduit,
    String? referenceCommerciale,
    String? numeroCommande,
    String? dateCommande,
    String? dateProductionUsine,
    String? lotProduction,
    String? numeroSerie,
    String? codeEAN,
    String? adresseMAC,
    String? versionHardware,
    String? versionFirmware,
    String? motdepasseFTP,
    String? motdepasseAdmin,
    int? supportWIFI,
    String? ssid,
    String? cleWEP,
    String? typeADSL,
    String? numdec,
    String? marque,
  }) {
    return Equipement(
      id: id ?? this.id,
      typeEquipement: typeEquipement ?? this.typeEquipement,
      nomFournisseur: nomFournisseur ?? this.nomFournisseur,
      referenceProduit: referenceProduit ?? this.referenceProduit,
      typeProduit: typeProduit ?? this.typeProduit,
      referenceCommerciale: referenceCommerciale ?? this.referenceCommerciale,
      numeroCommande: numeroCommande ?? this.numeroCommande,
      dateCommande: dateCommande ?? this.dateCommande,
      dateProductionUsine: dateProductionUsine ?? this.dateProductionUsine,
      lotProduction: lotProduction ?? this.lotProduction,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      codeEAN: codeEAN ?? this.codeEAN,
      adresseMAC: adresseMAC ?? this.adresseMAC,
      versionHardware: versionHardware ?? this.versionHardware,
      versionFirmware: versionFirmware ?? this.versionFirmware,
      motdepasseFTP: motdepasseFTP ?? this.motdepasseFTP,
      motdepasseAdmin: motdepasseAdmin ?? this.motdepasseAdmin,
      supportWIFI: supportWIFI ?? this.supportWIFI,
      ssid: ssid ?? this.ssid,
      cleWEP: cleWEP ?? this.cleWEP,
      typeADSL: typeADSL ?? this.typeADSL,
      numdec: numdec ?? this.numdec,
      marque: marque ?? this.marque,
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'typeEquipement': typeEquipement,
      'nomFournisseur': nomFournisseur,
      'referenceProduit': referenceProduit,
      'typeProduit': typeProduit,
      'referenceCommerciale': referenceCommerciale,
      'numeroCommande': numeroCommande,
      'dateCommande': dateCommande,
      'dateProductionUsine': dateProductionUsine,
      'lotProduction': lotProduction,
      'numeroSerie': numeroSerie,
      'codeEAN': codeEAN,
      'adresseMAC': adresseMAC,
      'versionHardware': versionHardware,
      'versionFirmware': versionFirmware,
      'motdepasseFTP': motdepasseFTP,
      'motdepasseAdmin': motdepasseAdmin,
      'supportWIFI': supportWIFI,
      'ssid': ssid,
      'cleWEP': cleWEP,
      'typeADSL': typeADSL,
      'numdec': numdec,
      'marque': marque,
    };
  }

  factory Equipement.fromMap(Map<String, dynamic> map) {
    return Equipement(
      id: map['id'] != null ? map['id'] as int : null,
      typeEquipement: map['typeEquipement'] != null ? map['typeEquipement'] as String : null,
      nomFournisseur: map['nomFournisseur'] != null
          ? map['nomFournisseur'] as String
          : null,
      referenceProduit: map['referenceProduit'] != null
          ? map['referenceProduit'] as String
          : null,
      typeProduit:
          map['typeProduit'] != null ? map['typeProduit'] as String : null,
      referenceCommerciale: map['referenceCommerciale'] != null
          ? map['referenceCommerciale'] as String
          : null,
      numeroCommande: map['numeroCommande'] != null
          ? map['numeroCommande'] as String
          : null,
      dateCommande:
          map['dateCommande'] != null ? map['dateCommande'] as String : null,
      dateProductionUsine: map['dateProductionUsine'] != null
          ? map['dateProductionUsine'] as String
          : null,
      lotProduction:
          map['lotProduction'] != null ? map['lotProduction'] as String : null,
      numeroSerie:
          map['numeroSerie'] != null ? map['numeroSerie'] as String : null,
      codeEAN: map['codeEAN'] != null ? map['codeEAN'] as String : null,
      adresseMAC:
          map['adresseMAC'] != null ? map['adresseMAC'] as String : null,
      versionHardware: map['versionHardware'] != null
          ? map['versionHardware'] as String
          : null,
      versionFirmware: map['versionFirmware'] != null
          ? map['versionFirmware'] as String
          : null,
      motdepasseFTP:
          map['motdepasseFTP'] != null ? map['motdepasseFTP'] as String : null,
      motdepasseAdmin: map['motdepasseAdmin'] != null
          ? map['motdepasseAdmin'] as String
          : null,
      supportWIFI:
          map['supportWIFI'] != null ? map['supportWIFI'] as int : null,
      ssid: map['ssid'] != null ? map['ssid'] as String : null,
      cleWEP: map['cleWEP'] != null ? map['cleWEP'] as String : null,
      typeADSL: map['typeADSL'] != null ? map['typeADSL'] as String : null,
      numdec: map['numdec'] != null ? map['numdec'] as String : null,
      marque: map['marque'] != null ? map['marque'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Equipement.fromJson(String source) =>
      Equipement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Equipement(id: $id, typeEquipement: $typeEquipement, nomFournisseur: $nomFournisseur, referenceProduit: $referenceProduit, typeProduit: $typeProduit, referenceCommerciale: $referenceCommerciale, numeroCommande: $numeroCommande, dateCommande: $dateCommande, dateProductionUsine: $dateProductionUsine, lotProduction: $lotProduction, numeroSerie: $numeroSerie, codeEAN: $codeEAN, adresseMAC: $adresseMAC, versionHardware: $versionHardware, versionFirmware: $versionFirmware, motdepasseFTP: $motdepasseFTP, motdepasseAdmin: $motdepasseAdmin, supportWIFI: $supportWIFI, ssid: $ssid, cleWEP: $cleWEP, typeADSL: $typeADSL, numdec: $numdec, marque: $marque)';
  }

  @override
  bool operator ==(covariant Equipement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.typeEquipement == typeEquipement &&
        other.nomFournisseur == nomFournisseur &&
        other.referenceProduit == referenceProduit &&
        other.typeProduit == typeProduit &&
        other.referenceCommerciale == referenceCommerciale &&
        other.numeroCommande == numeroCommande &&
        other.dateCommande == dateCommande &&
        other.dateProductionUsine == dateProductionUsine &&
        other.lotProduction == lotProduction &&
        other.numeroSerie == numeroSerie &&
        other.codeEAN == codeEAN &&
        other.adresseMAC == adresseMAC &&
        other.versionHardware == versionHardware &&
        other.versionFirmware == versionFirmware &&
        other.motdepasseFTP == motdepasseFTP &&
        other.motdepasseAdmin == motdepasseAdmin &&
        other.supportWIFI == supportWIFI &&
        other.ssid == ssid &&
        other.cleWEP == cleWEP &&
        other.typeADSL == typeADSL &&
        other.numdec == numdec &&
        other.marque == marque;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        typeEquipement.hashCode ^
        nomFournisseur.hashCode ^
        referenceProduit.hashCode ^
        typeProduit.hashCode ^
        referenceCommerciale.hashCode ^
        numeroCommande.hashCode ^
        dateCommande.hashCode ^
        dateProductionUsine.hashCode ^
        lotProduction.hashCode ^
        numeroSerie.hashCode ^
        codeEAN.hashCode ^
        adresseMAC.hashCode ^
        versionHardware.hashCode ^
        versionFirmware.hashCode ^
        motdepasseFTP.hashCode ^
        motdepasseAdmin.hashCode ^
        supportWIFI.hashCode ^
        ssid.hashCode ^
        cleWEP.hashCode ^
        typeADSL.hashCode ^
        numdec.hashCode ^
        marque.hashCode;
  }

  String get getAddressmac => adresseMAC ?? "0000000000";
  String get getnumdec => numdec ?? "XXXXXXXXXX";
  String get getnumeroSerie => numeroSerie ?? "0000000000";
  String get getmarque => marque ?? "- - - - -";
  String get getcodeEAN => codeEAN ?? "0000000000";
  String? get getType => typeEquipement?.toUpperCase();

  String get formatedAddressMAC => getAddressmac
      .splitMapJoin(RegExp(r'[a-zA-Z0-9]{2}'), onMatch: (m) => ':${m[0]}')
      .substring(1);

  /*-----------------------------------------------------------------------------*/
  /*-----------------------------    FETCH METHODS  -----------------------------*/
  /*-----------------------------------------------------------------------------*/

  static Future<List<Equipement>> get(
      BuildContext context, String param) async {
    var data = await OAuthManager.of(context)!.get(context,
        "${ApplicationConfiguration.instance!.webapipfs}/equipement/$param");
    return List.from(data.map((e) => Equipement.fromMap(e)));
  }
}
