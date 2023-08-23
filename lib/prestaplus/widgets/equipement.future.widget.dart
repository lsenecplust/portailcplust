import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';

import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:librairies/futurebuilder.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class EquipementFuture extends StatelessWidget {
  final DeviceBarCodes? scannedbarcode;
  final bool modeEchange;
  final String? param;
  final Future<List<Equipement>> future;
  final MigAction? migaction;
  final Function(Equipement equipment)? onSelectedequipment;
  const EquipementFuture(
      {super.key,
      this.param,
      this.onSelectedequipment,
      this.modeEchange = false,
      this.scannedbarcode,
      required this.future,
      this.migaction});

  String? get numdec => param ?? scannedbarcode?.numdec;

  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;
    if (numdec == null) return Container();

    void movetomanuel() {
      ScaffoldTabs.of(context)
          ?.movetomanual(scannedbarcode ?? DeviceBarCodes(numdec: param));
    }

    return Column(
      children: [
        Text(
          "Résultat(s) de $numdec",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: EnhancedFutureBuilder(
            progressIndicator: const PortailIndicator(),
            future: future,
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

              return EquipementList(
                equipements: equipements,
                modeEchange: modeEchange,
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
  }
}

class EquipementList extends StatefulWidget {
  final List<Equipement> equipements;
  final ValueChanged<Equipement> onSelected;
  final bool modeEchange;

  const EquipementList({
    Key? key,
    required this.equipements,
    required this.onSelected,
    this.modeEchange = false,
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
                isSelected: widget.modeEchange
                    ? context.exchangeEquipementController
                            ?.geValidatedEquipement ==
                        e
                    : equipmentSelected == e,
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
