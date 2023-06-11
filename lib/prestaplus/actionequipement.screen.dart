import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/affecterrestituer.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.screen.dart';

class ActionEquipementScreen extends StatefulWidget {
  final Prestation prestation;
  final MigAction migaction;
  const ActionEquipementScreen({
    Key? key,
    required this.prestation,
    required this.migaction,
  }) : super(key: key);

  @override
  State<ActionEquipementScreen> createState() => _ActionEquipementScreenState();
}

class _ActionEquipementScreenState extends State<ActionEquipementScreen> {
  @override
  Widget build(BuildContext context) {
    switch (widget.migaction.type!) {
      case (EnumMigAction.affectation):
        return AffecterRestituer(
            action: action,
            prestation: widget.prestation,
            migaction: widget.migaction);
      case (EnumMigAction.restitution):
        return AffecterRestituer(
            action: action,
            prestation: widget.prestation,
            migaction: widget.migaction);
      case (EnumMigAction.echange):
        return Echange(
            prestation: widget.prestation, migaction: widget.migaction);
    }
  }

  Future<bool> action() async {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();
    return Future.delayed(Duration(milliseconds: min + rnd.nextInt(max - min)))
        .then((value) => rnd.nextInt(max).isEven);
  }
}
