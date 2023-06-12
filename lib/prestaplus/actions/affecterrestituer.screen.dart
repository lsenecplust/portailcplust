import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/searchorscan.widget.dart';

class AffecterRestituer extends StatefulWidget {
  final Prestation prestation;
  final MigAction migaction;
  final Function(Equipement? equipement, String? param)? onSelected;
  const AffecterRestituer({
    Key? key,
    required this.prestation,
    required this.migaction,
    this.onSelected,
  }) : super(key: key);

  @override
  State<AffecterRestituer> createState() => _AffecterRestituerState();
}

class _AffecterRestituerState extends State<AffecterRestituer> {
  String? searchPattern;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Prestation",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrestationCard(prestation: widget.prestation),
            ),
            SearchOrScanSwitch(
              onchange: (value) {
                setState(() {
                  searchPattern = value;
                });
              },
            ),
            EquipementFuture(
              migaction: widget.migaction,
              onSelectedequipment: widget.onSelected,
              param: searchPattern,
            ),
          ],
        ),
      ),
    );
  }


}
