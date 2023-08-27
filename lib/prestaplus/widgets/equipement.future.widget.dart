// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:librairies/futurebuilder.dart';

import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class EquipementFuture extends StatelessWidget {
  final DeviceBarCodes? scannedbarcode;
  final bool modeEchange;
  final String? param;
  final Future<dynamic> future;
  final MigAction? migaction;

  final Function(Equipement equipment) onSelectedequipment;
  const EquipementFuture({
    Key? key,
    this.scannedbarcode,
    this.modeEchange = false,
    this.param,
    required this.future,
    this.migaction,
    required this.onSelectedequipment,
  })  : assert(
            future is Future<Equipement> || future is Future<List<Equipement>>),
        super(key: key);

  String? get numdec => param ?? scannedbarcode?.numdec;

  @override
  Widget build(BuildContext context) {
    if (numdec == null) return Container();

    void movetomanual() {
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
            child: switch (future) {
          _ when future is Future<Equipement> => _EquipementFuture(
              key: key,
              scannedbarcode: scannedbarcode,
              numdec: numdec,
              modeEchange: modeEchange,
              future: future.then((value) => value as Equipement),
              movetomanual: movetomanual,
              migaction: migaction,
              onSelectedequipment: onSelectedequipment,
            ),
          _ when future is Future<List<Equipement>> => _ListEquipementFuture(
              key: key,
              numdec: numdec,
              scannedbarcode: scannedbarcode,
              modeEchange: modeEchange,
              future: future.then((value) => value as List<Equipement>),
              movetomanual: movetomanual,
              migaction: migaction,
              onSelectedequipment: onSelectedequipment,
            ),
          // Else case
          _ => const Text('Unknown state encountered'),
        })
      ],
    );
  }
}

class _EquipementFuture extends StatelessWidget {
  final DeviceBarCodes? scannedbarcode;
  final bool modeEchange;
  final Future<Equipement> future;
  final MigAction? migaction;
  final String? numdec;

  final Function(Equipement equipment) onSelectedequipment;
  final void Function()? movetomanual;

  const _EquipementFuture({
    Key? key,
    this.scannedbarcode,
    required this.modeEchange,
    required this.future,
    this.migaction,
    this.numdec,
    required this.onSelectedequipment,
    this.movetomanual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      progressIndicator: const PortailIndicator(),
      future: future,
      builder: (context, snapshot) {
        var equipements = snapshot.data!;
        return EquipementCard(
          equipement: equipements,
          isSelected: false,
          ontap: onSelectedequipment,
        );
      },
      errorBuilder: (context, snapshot) => _NotfoundEquipement(
        movetomanual: movetomanual,
        numdec: numdec,
      ),
    );
  }
}

class _ListEquipementFuture extends StatelessWidget {
  final DeviceBarCodes? scannedbarcode;
  final bool modeEchange;
  final String? numdec;
  final Future<List<Equipement>> future;
  final MigAction? migaction;
  final Function(Equipement equipment)? onSelectedequipment;
  final void Function()? movetomanual;
  const _ListEquipementFuture(
      {super.key,
      this.onSelectedequipment,
      this.modeEchange = false,
      this.scannedbarcode,
      required this.future,
      required this.movetomanual,
      required this.numdec,
      this.migaction});

  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;

    return EnhancedFutureBuilder(
      progressIndicator: const PortailIndicator(),
      future: future,
      builder: (context, snapshot) {
        var equipements = snapshot.data!;
        if (equipements.isEmpty) {
          equipmentSelected = null;
          return Center(
            child: InkWell(
              onTap: movetomanual,
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
    );
  }
}

class _NotfoundEquipement extends StatelessWidget {
  final String? numdec;
  final void Function()? movetomanual;

  const _NotfoundEquipement({
    Key? key,
    required this.numdec,
    required this.movetomanual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: movetomanual,
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
