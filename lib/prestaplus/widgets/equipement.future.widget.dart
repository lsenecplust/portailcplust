import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';

import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class EquipementFuture extends StatelessWidget {
  final String? param;
  final MigAction? migaction;
  final Function(EquipementQuery equipment)? onSelectedequipment;
  const EquipementFuture(
      {super.key,
      required this.param,
      this.onSelectedequipment,
      this.migaction});

  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;
    if (param == null) return Container();
    if (param!.isEmpty) return Container();

    Future<List<Equipement>> getEquipement() async {
      try {
        var eqs = await Equipement.get(context, param!);
        return eqs;
      } on NotFound catch (_) {
        return List.empty();
      }
    }

    return LayoutBuilder(builder: (context, constraint) {
      var textresultheight = 40;
      return Column(
        children: [
          Text(
            //Textheight 40
            "Résultat(s) de $param",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: constraint.maxHeight - textresultheight,
            child: CustomFutureBuilder(
              future: getEquipement(),
              builder: (context, snapshot) {
                var equipements = snapshot.data!;
                if (equipements.isEmpty) {
                  equipmentSelected = null;
                  return Center(
                    child: SizedBox(
                      height: 150,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(Icons.no_cell_rounded),
                              const Text("équipement introuvable"),
                              Text(
                                  "si $param est le numdec vous pouvez poursuivre l'opération"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (equipements.length == 1) {
                  equipmentSelected = equipements.first;
                  Future.microtask(() => onSelectedequipment?.call(
                      EquipementQuery(
                          equipement: equipmentSelected,
                          numdec: param!,
                          type: migaction?.typeEquipement)));
                }

                return EquipementList(
                  equipements: equipements,
                  onSelected: (value) {
                    equipmentSelected = value;
                    onSelectedequipment?.call(EquipementQuery(
                        equipement: equipmentSelected,
                        numdec: param!,
                        type: migaction?.typeEquipement));
                  },
                );
              },
            ),
          ),
        ],
      );
    });
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
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(bottom: equipmentSelected == null ? 0 : 80),
      child: ListView(
        children: [
          ...widget.equipements.map((e) => EquipementCard(
                equipement: e,
                isSelected: equipmentSelected == e,
                ontap: (equipement) {
                  setState(() {
                    equipmentSelected = equipement;
                  });
                  widget.onSelected(equipement);
                },
              )),
        ],
      ),
    );
  }
}
