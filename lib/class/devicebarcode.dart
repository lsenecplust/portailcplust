import 'dart:convert';

import 'package:portail_canalplustelecom_mobile/class/scan.result.extension.dart';
import 'package:portail_canalplustelecom_mobile/class/scanresult.dart';

class DeviceBarCodes {
  String? numeroSerie;
  String? adresseMAC;
  String? numdec;
  String? ontSerial;

  DeviceBarCodes({
    this.numeroSerie,
    this.adresseMAC,
    this.numdec,
    this.ontSerial,
  });

  bool get isNull =>
      [adresseMAC, numeroSerie, numdec].every((element) => element == null);

  static String? getNumdec(List<ScanResult> scanResults) =>
      scanResults.where((element) => element.isNumdec).lastOrNull?.data;

  static String? getMac(List<ScanResult> scanResults) =>
      scanResults.where((element) => element.isMac).lastOrNull?.data;

  static String? getOntSerial(List<ScanResult> scanResults) =>
      scanResults.where((element) => element.isOntSerial).lastOrNull?.data;

  static String? getSerial(List<ScanResult> scanResults) =>
      scanResults.where((element) => element.isSerial).lastOrNull?.data;

  DeviceBarCodes copyWith({
    String? serialnumber,
    String? mac,
    String? numdec,
    String? ontSerial,
  }) {
    return DeviceBarCodes(
      numeroSerie: serialnumber ?? numeroSerie,
      adresseMAC: mac ?? adresseMAC,
      numdec: numdec ?? this.numdec,
      ontSerial: ontSerial ?? this.ontSerial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serialnumber': numeroSerie,
      'mac': adresseMAC,
      'numdec': numdec,
      'ontSerial': ontSerial,
    };
  }

  factory DeviceBarCodes.fromScanResult(List<ScanResult> scanresult) {
    String? numdec, mac, ontSerial, serial;

    numdec = DeviceBarCodes.getNumdec(scanresult);
    mac = DeviceBarCodes.getMac(
        scanresult.where((element) => element.data != numdec).toList());
    ontSerial = DeviceBarCodes.getOntSerial(scanresult);
    serial = DeviceBarCodes.getSerial(scanresult);

    return DeviceBarCodes(
        numdec: numdec,
        adresseMAC: mac,
        numeroSerie: serial,
        ontSerial: ontSerial);
  }

  factory DeviceBarCodes.fromMap(Map<String, dynamic> map) {
    return DeviceBarCodes(
      numeroSerie:
          map['serialnumber'] != null ? map['serialnumber'] as String : null,
      adresseMAC: map['mac'] != null ? map['mac'] as String : null,
      numdec: map['numdec'] != null ? map['numdec'] as String : null,
      ontSerial: map['ontSerial'] != null ? map['ontSerial'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceBarCodes.fromJson(String source) =>
      DeviceBarCodes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeviceBarCodes(serialnumber: $numeroSerie, mac: $adresseMAC, numdec: $numdec, ontSerial: $ontSerial)';
  }

  @override
  bool operator ==(covariant DeviceBarCodes other) {
    if (identical(this, other)) return true;

    return other.numeroSerie == numeroSerie &&
        other.adresseMAC == adresseMAC &&
        other.numdec == numdec &&
        other.ontSerial == ontSerial;
  }

  @override
  int get hashCode {
    return numeroSerie.hashCode ^
        adresseMAC.hashCode ^
        numdec.hashCode ^
        ontSerial.hashCode;
  }
}
