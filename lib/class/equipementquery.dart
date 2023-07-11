// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EquipementQuery {
  final Equipement? equipement;
  final String numdec;
  final String? type;

  EquipementQuery({
    this.equipement,
    required this.numdec,
    required this.type,
  });

  String get getNumdec => equipement?.numdec ?? numdec;
  String? get getType => (equipement?.type ?? type)?.toUpperCase();
}
