import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

enum SelectedEquipement { older, newer }

class ExchangeEquipementController {
  EquipementValidated equipementValidated;
  EquipementBeingEntered equipementBeingEntered;
  SelectedEquipement selectedEquipement;
  DeviceBarCodes? lastScan;

  ExchangeEquipementController(
      {EquipementBeingEntered? equipementBeingEntered,
      EquipementValidated? equipementValidated,
      this.selectedEquipement = SelectedEquipement.older,
      DeviceBarCodes? lastScan})
      : equipementValidated = equipementValidated ?? EquipementValidated(),
        equipementBeingEntered =
            equipementBeingEntered ?? EquipementBeingEntered(),
        lastScan = lastScan ?? DeviceBarCodes();

  bool get isNewer => selectedEquipement == SelectedEquipement.newer;
  bool get isOlder => !isNewer;

  Equipement? get getCurrentEquipement => isNewer
      ? equipementBeingEntered.newerEquipement
      : equipementBeingEntered.olderEquipement;
  set setCurrentEquipement(Equipement? value) => isNewer
      ? equipementBeingEntered.newerEquipement = value
      : equipementBeingEntered.olderEquipement = value;

  Equipement? get geValidatedEquipement => isNewer
      ? equipementValidated.newerEquipement
      : equipementValidated.olderEquipement;
  set setValidatedEquipement(Equipement? value) => isNewer
      ? equipementValidated.newerEquipement = value
      : equipementValidated.olderEquipement = value;

  updateCurrent({String? numdec, String? numeroSerie, String? addressMac}) {
    var eq = (getCurrentEquipement ?? Equipement()).copyWith(
        numdec: numdec, adresseMAC: addressMac, numeroSerie: numeroSerie);
    setCurrentEquipement = eq;
  }
}

class EquipementBeingEntered {
  Equipement? olderEquipement;
  Equipement? newerEquipement;

  EquipementBeingEntered({
    this.olderEquipement,
    this.newerEquipement,
  });
}

class EquipementValidated {
  Equipement? olderEquipement;
  Equipement? newerEquipement;

  EquipementValidated({
    this.olderEquipement,
    this.newerEquipement,
  });
}

extension NumberParsing on BuildContext {
  ExchangeEquipementController? get exchangeEquipementController =>
      ScaffoldTabs.of(this)?.exchangeEquipementController;

  SelectedEquipement? get selectedEquipement =>
      exchangeEquipementController?.selectedEquipement;

  EquipementBeingEntered? get equipementBeingEntered =>
      exchangeEquipementController?.equipementBeingEntered;

  EquipementValidated? get equipementValidated =>
      exchangeEquipementController?.equipementValidated;

  set selectedEquipement(SelectedEquipement? value) =>
      exchangeEquipementController?.selectedEquipement = value!;
}
