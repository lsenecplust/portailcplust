import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EquipementQuery {
  final Equipement? equipement;
  final String numdec;

  EquipementQuery({required this.numdec, this.equipement});

  String get getNumdec => equipement?.numdec ?? numdec;
}