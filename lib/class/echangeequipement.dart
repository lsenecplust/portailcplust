import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EchangeEquipment {
  final Equipement? equipement;
  final String numdec;

  EchangeEquipment({required this.numdec, this.equipement});

  String get getNumdec => equipement?.numdec ?? numdec;
}