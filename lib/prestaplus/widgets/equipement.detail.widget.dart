import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';

import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EquipementDetail extends StatelessWidget {
  final Equipement? equipement;
  const EquipementDetail({
    Key? key,
    this.equipement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.router,
          size: 100,
          color: lightColorScheme.outline,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("numdec"),
                Text("S/N"),
                Text("MAC"),
                Text("marque"),
                Text("EAN"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(equipement?.numdec ?? "---"),
                Text(equipement?.numeroSerie ?? "---"),
                Text(equipement?.formatedAddressMAC ?? "---"),
                Text(equipement?.marque ?? "---"),
                Text(equipement?.codeEAN ?? "---"),
              ],
            ),
          ],
        )
      ],
    );
  }
}
