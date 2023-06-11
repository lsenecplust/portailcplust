import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EquipementCard extends StatelessWidget {
  final Equipement equipement;
  final bool isSelected;
  final Function(Equipement equipement) ontap;
  const EquipementCard({
    Key? key,
    required this.equipement,
    this.isSelected=false,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ontap(equipement),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration:  BoxDecoration(
              color:isSelected? lightColorScheme.secondary.withOpacity(0.1): Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              boxShadow: [
                BoxShadow(
                    color: lightColorScheme.primary,
                    offset: const Offset(-7, 0),
                    blurRadius: 0,
                    spreadRadius: 0),
                const BoxShadow(
                    color: CustomColors.gray400,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    spreadRadius: 2.0),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.router),
                Text(equipement.numdec),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("S/N ${equipement.numeroSerie}"),
                    Text(equipement.formatedAdressMAC),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(equipement.marque),
                    Text(equipement.codeEAN),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}


