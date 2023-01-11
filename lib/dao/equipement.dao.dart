import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/authenticatedhttp.dart';
import 'package:portail_canalplustelecom_mobile/class/constante.dart';

class Equipement {
  final int id;
  final String type;
  final String nomFournisseur;
  final String referenceProduit;
  final String typeProduit;
  final String referenceCommerciale;
  final String numeroCommande;
  final String dateCommande;
  final String dateProductionUsine;
  final String lotProduction;
  final String numeroSerie;
  final String codeEAN;
  final String adresseMAC;
  final String versionHardware;
  final String versionFirmware;
  final String motdepasseFTP;
  final String motdepasseAdmin;
  final int supportWIFI;
  final String ssid;
  final String cleWEP;
  final String typeADSL;
  final String numdec;
  final String marque;
  Equipement({
    required this.id,
    required this.type,
    required this.nomFournisseur,
    required this.referenceProduit,
    required this.typeProduit,
    required this.referenceCommerciale,
    required this.numeroCommande,
    required this.dateCommande,
    required this.dateProductionUsine,
    required this.lotProduction,
    required this.numeroSerie,
    required this.codeEAN,
    required this.adresseMAC,
    required this.versionHardware,
    required this.versionFirmware,
    required this.motdepasseFTP,
    required this.motdepasseAdmin,
    required this.supportWIFI,
    required this.ssid,
    required this.cleWEP,
    required this.typeADSL,
    required this.numdec,
    required this.marque,
  });

  Equipement copyWith({
    int? id,
    String? type,
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
      type: type ?? this.type,
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
      'type': type,
      'nom_fournisseur': nomFournisseur,
      'reference_produit': referenceProduit,
      'type_produit': typeProduit,
      'reference_commerciale': referenceCommerciale,
      'numero_commande': numeroCommande,
      'date_commande': dateCommande,
      'date_production_usine': dateProductionUsine,
      'lot_production': lotProduction,
      'numero_serie': numeroSerie,
      'code_ean': codeEAN,
      'adresse_mac': adresseMAC,
      'version_hardware': versionHardware,
      'version_firmware': versionFirmware,
      'motdepasse_ftp': motdepasseFTP,
      'motdepasse_admin': motdepasseAdmin,
      'support_wifi': supportWIFI,
      'ssid': ssid,
      'cle_wep': cleWEP,
      'type_adsl': typeADSL,
      'numdec': numdec,
      'marque': marque,
    };
  }

  factory Equipement.fromMap(Map<String, dynamic> map) {
    return Equipement(
      id: map['id'].toInt() as int,
      type: map['type'] as String,
      nomFournisseur: map['nom_fournisseur'] as String,
      referenceProduit: map['reference_produit'] as String,
      typeProduit: map['type_produit'] as String,
      referenceCommerciale: map['reference_commerciale'] as String,
      numeroCommande: map['numero_commande'] as String,
      dateCommande: map['date_commande'] as String,
      dateProductionUsine: map['date_production_usine'] as String,
      lotProduction: map['lot_production'] as String,
      numeroSerie: map['numero_serie'] as String,
      codeEAN: map['code_ean'] as String,
      adresseMAC: map['adresse_mac'] as String,
      versionHardware: map['version_hardware'] as String,
      versionFirmware: map['version_firmware'] as String,
      motdepasseFTP: map['motdepasse_ftp'] as String,
      motdepasseAdmin: map['motdepasse_admin'] as String,
      supportWIFI: map['support_wifi'].toInt() as int,
      ssid: map['ssid'] as String,
      cleWEP: map['cle_wep'] as String,
      typeADSL: map['type_adsl'] as String,
      numdec: map['numdec'] as String,
      marque: map['marque'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Equipement.fromJson(String source) =>
      Equipement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Equipement(id: $id, type: $type, nom_fournisseur: $nomFournisseur, reference_produit: $referenceProduit, type_produit: $typeProduit, reference_commerciale: $referenceCommerciale, numero_commande: $numeroCommande, date_commande: $dateCommande, date_production_usine: $dateProductionUsine, lot_production: $lotProduction, numero_serie: $numeroSerie, code_ean: $codeEAN, adresse_mac: $adresseMAC, version_hardware: $versionHardware, version_firmware: $versionFirmware, motdepasse_ftp: $motdepasseFTP, motdepasse_admin: $motdepasseAdmin, support_wifi: $supportWIFI, ssid: $ssid, cle_wep: $cleWEP, type_adsl: $typeADSL, numdec: $numdec, marque: $marque)';
  }

  @override
  bool operator ==(covariant Equipement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
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
        type.hashCode ^
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

  String get formatedAdressMAC => adresseMAC
      .splitMapJoin(RegExp(r'[a-zA-Z0-9]{2}'), onMatch: (m) => ':${m[0]}').substring(1);

  /*-----------------------------------------------------------------------------*/
  /*-----------------------------    FETCH METHODS  -----------------------------*/
  /*-----------------------------------------------------------------------------*/

  static Future<List<Equipement>> get(
      BuildContext context, String param) async {
    var data = await AuthenticatedHttp.instance
        .get(context, "${Constantes.webApihost}/equipement/$param");
    return List.from(data.map((e) => Equipement.fromMap(e)));
  }
}
