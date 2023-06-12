import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class EquipementFuture extends StatelessWidget {
  final String? param;
  final MigAction? migaction;
  final Function(Equipement? equipement, String? param)? onSelectedequipment;
  const EquipementFuture(
      {super.key,
      required this.param,
      this.migaction,
      this.onSelectedequipment});

  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;
    if (param?.isEmpty ?? true) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Résultat(s) de $param",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        CustomFutureBuilder(
          future: Equipement.get(context, param!),
          builder: (context, snapshot) {
            var equipements = snapshot.data!;
            if (equipements.isEmpty) {
              equipmentSelected = null;
              onSelectedequipment?.call(null, param);
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(Icons.no_cell_rounded),
                      Text("Aucun équipement trouvée"),
                    ],
                  ),
                ),
              );
            }

            if (equipements.length == 1) {
              equipmentSelected = equipements.first;
              onSelectedequipment?.call(equipmentSelected, param);
            }

            return EquipementList(
              equipements: equipements,
              onSelected: (value) {
                equipmentSelected = value;
                onSelectedequipment?.call(equipmentSelected, param);
              },
            );
          },
        ),
      ],
    );
  }
}

class EquipementList extends StatefulWidget {
  final List<Equipement> equipements;
  final ValueChanged<Equipement> onSelected;
  const EquipementList({
    Key? key,
    required this.equipements,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<EquipementList> createState() => _EquipementListState();
}

class _EquipementListState extends State<EquipementList> {
  Equipement? equipmentSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.equipements.map((e) => EquipementCard(
              equipement: e,
              isSelected: equipmentSelected == e,
              ontap: (equipement) {
                debugPrint(equipmentSelected.toString());
                setState(() {
                  equipmentSelected = equipement;
                });
                widget.onSelected(equipement);
              },
            )),
      ],
    );
  }
}
