import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/class/exceptions.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';

import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class EquipementFuture extends StatelessWidget {
  final DeviceBarCodes? scannedbarcode;
  final String? param;
  final MigAction? migaction;
  final Function(Equipement equipment)? onSelectedequipment;
  const EquipementFuture(
      {super.key,
      this.param,
      this.onSelectedequipment,
      this.scannedbarcode,
      this.migaction});

  String? get numdec => param ?? scannedbarcode?.numdec;
  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;
    if (numdec == null) return Container();

    Future<List<Equipement>> getEquipement() async {
      try {
        var eqs = await Equipement.get(context, numdec!);
        return eqs;
      } on NotFound catch (_) {
        return List.empty();
      }
    }

    void movetomanuel() {
      ScaffoldTabs.of(context)?.movetomanual(scannedbarcode ?? DeviceBarCodes(numdec: param));
    }

    return LayoutBuilder(builder: (context, constraint) {
      var textresultheight = 40;
      return Column(
        children: [
          Text(
            //Textheight 40
            "Résultat(s) de $numdec",
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
                    child: InkWell(
                      onTap: movetomanuel,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.no_cell_rounded),
                              const Text("équipement introuvable"),
                              Text(
                                "si $numdec est le numdec",
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "cliquez pour poursuivre l'opération manuellement",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (equipements.length == 1) {
                  equipmentSelected = equipements.first;
                  Future.microtask(
                      () => onSelectedequipment?.call(equipmentSelected!));
                }

                return EquipementList(
                  equipements: equipements,
                  onSelected: (value) {
                    equipmentSelected = value;
                    onSelectedequipment?.call(equipmentSelected!);
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
