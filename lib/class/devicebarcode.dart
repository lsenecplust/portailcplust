// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  static bool isNumdec(String value) => RegExp(r'^[0-9]*$').hasMatch(value);
  static bool isOntSerial(String value) => value.startsWith('SMB');
  static bool isSerial(String value) => value.startsWith('N');

  static bool isMac(String value) =>
      RegExp(r'^([0-9A-Fa-f]{2}){6}$').hasMatch(value);

  static (String?, List<ScanResult>) getNumdec(List<ScanResult> scanResults) {
    var idx = scanResults.indexWhere((element) => isNumdec(element.data));
    if (idx == -1) return (null, scanResults);
    return (scanResults.removeAt(idx).data, scanResults);
  }

  static (String?, List<ScanResult>) getMac(List<ScanResult> scanResults) {
    var idx = scanResults.indexWhere((element) => isMac(element.data));
    if (idx == -1) return (null, scanResults);
    return (scanResults.removeAt(idx).data, scanResults);
  }

  static (String?, List<ScanResult>) getOntSerial(
      List<ScanResult> scanResults) {
    var idx = scanResults.indexWhere((element) => isOntSerial(element.data));
    if (idx == -1) return (null, scanResults);
    return (scanResults.removeAt(idx).data, scanResults);
  }

  static (String?, List<ScanResult>) getSerial(List<ScanResult> scanResults) {
    var idx = scanResults.indexWhere((element) => isSerial(element.data));
    if (idx == -1) return (null, scanResults);
    return (scanResults.removeAt(idx).data, scanResults);
  }

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
    List<ScanResult> scr;

    (numdec, scr) = DeviceBarCodes.getNumdec(scanresult);
    (mac, scr) = DeviceBarCodes.getMac(scr);
    (ontSerial, scr) = DeviceBarCodes.getOntSerial(scr);
    (serial, scr) = DeviceBarCodes.getSerial(scr);

    return DeviceBarCodes(
        numdec: numdec, adresseMAC: mac, numeroSerie: serial, ontSerial: ontSerial);
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
