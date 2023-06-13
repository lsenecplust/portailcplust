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
    this.isSelected = false,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ontap(equipement),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? lightColorScheme.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(71.0)),
                boxShadow: [
                  BoxShadow(
                      color: lightColorScheme.primary,
                      offset: const Offset(1, -1),
                      blurRadius: 0,
                      spreadRadius: 0),
                  BoxShadow(
                      color: lightColorScheme.primary,
                      offset: const Offset(1, 1),
                      blurRadius: 0,
                      spreadRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 110,
                      width: 71,
                      decoration: BoxDecoration(
                        color: lightColorScheme.primary,
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(71.0),bottomLeft: Radius.circular(71.0)),
                      ),
                      child: const Icon(
                        Icons.router,
                        size: 50,
                        color: Colors.white,
                      )),
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
                      Text(equipement.numdec),
                      Text(equipement.numeroSerie),
                      Text(equipement.formatedAdressMAC),
                      Text(equipement.marque),
                      Text(equipement.codeEAN),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
