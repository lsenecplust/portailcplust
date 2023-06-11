import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class EquipementFuture extends StatelessWidget {
  final String? param;
  final MigAction? migaction;
  final Function(Equipement?)? action;
  final ValueChanged<Equipement?>? onselectedequipment;
  const EquipementFuture(
      {super.key,
      required this.param,
      this.action,
      this.migaction,
      this.onselectedequipment});

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

            if (equipements.length == 1) equipmentSelected = equipements.first;

            return EquipementList(
              equipements: equipements,
              onSelected: (value) {
                equipmentSelected = value;
              },
            );
          },
        ),
        Visibility(
          visible: migaction != null,
          child: Center(
            child: FilledButton.icon(
                icon: const Icon(Icons.ads_click_sharp),
                onPressed: () => action?.call(equipmentSelected,),
                label: Text("forcer ${migaction?.tache ?? "action"}")),
          ),
        )
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
