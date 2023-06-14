import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';

class ScannerEquipement extends StatelessWidget {
  final Prestation? prestation;
  final MigAction migAction;
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
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
        onSubmit: onSubmit,
      );
    }
    return ScannerEquipementSimple(
      onSelected: (param) => onSubmit(param, null),
    );
  }
}

class ScannerEquipementSimple extends StatelessWidget {
  final Prestation? prestation;
  final Function(EquipementQuery equipment)? onSelected;

  const ScannerEquipementSimple({
    Key? key,
    this.prestation,
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
      child: BarCodeScanner(onSelected: (eq) => onSelected?.call(eq)),
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
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
  const ScannerEquipementEchange({
    Key? key,
    this.prestation,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ScannerEquipementEchange> createState() =>
      _ScannerEquipementEchangeState();
}

class _ScannerEquipementEchangeState extends State<ScannerEquipementEchange> {
  EquipementQuery? nouvelEquipement;
  EquipementQuery? ancienEquipement;
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        EchangeEquipementRecap(
          nouvelEquipement: nouvelEquipement,
          ancienEquipement: ancienEquipement,
        ),
        Expanded(
          child: ScannerEquipementSimple(onSelected: (equipement) {
            var (pnouvelEquipement, pancienEquipement) =
                EchangeEquipementRecap.affectEquipement(
                    equipement, nouvelEquipement, ancienEquipement);
            setState(() {
              nouvelEquipement = pnouvelEquipement;
              ancienEquipement = pancienEquipement;
            });
            widget.onSubmit(nouvelEquipement, ancienEquipement);
          }),
        )
      ],
    );
  }
}
