// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';

class ScannerEquipement extends StatelessWidget {
  final Prestation? prestation;
  final MigAction migAction;
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  const ScannerEquipement({
    Key? key,
    this.prestation,
    required this.migAction,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (migAction.type == EnumMigAction.echange) {
      return ScannerEquipementEchange(
        migaction: migAction,
        onSubmit: onSubmit,
      );
    }
    return ScannerEquipementSimple(
      migaction: migAction,
      onSelected: (param) => onSubmit(param, null),
    );
  }
}

class ScannerEquipementSimple extends StatelessWidget {
  final Prestation? prestation;
  final MigAction migaction;
  final Function(Equipement equipment)? onSelected;

  const ScannerEquipementSimple({
    Key? key,
    this.prestation,
    required this.migaction,
    this.onSelected,
  }) : super(key: key);

  List<Widget> buildItems(BuildContext context) {
    List<Widget> listItem = List.empty(growable: true);
    if (prestation != null) {
      listItem.addAll([
        Text(
          "Prestation",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrestationCard(prestation: prestation!),
        ),
      ]);
    }

    listItem.add(Expanded(
      child: BarCodeScanner(
          migaction: migaction, onSelected: (eq) => onSelected?.call(eq)),
    ));

    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildItems(context),
    );
  }
}

class ScannerEquipementEchange extends StatefulWidget {
  final Prestation? prestation;
  final MigAction migaction;
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  const ScannerEquipementEchange({
    Key? key,
    this.prestation,
    required this.migaction,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ScannerEquipementEchange> createState() =>
      _ScannerEquipementEchangeState();
}

class _ScannerEquipementEchangeState extends State<ScannerEquipementEchange> {
  Equipement? currentEquipement;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EchangeEquipementSwitcher(
          onswitch: (equipement) => setState(() {
            currentEquipement = equipement;
          }),
        ),
        Expanded(
          child: ScannerEquipementSimple(
              migaction: widget.migaction,
              onSelected: (equipement) {
                setState(() {});
                context.exchangeEquipementController?.setValidatedEquipement =
                    equipement.copyWith(
                        typeEquipement: widget.migaction.typeEquipement);
                widget.onSubmit(context.equipementValidated?.newerEquipement,
                    context.equipementValidated?.olderEquipement);
              }),
        )
      ],
    );
  }
}
