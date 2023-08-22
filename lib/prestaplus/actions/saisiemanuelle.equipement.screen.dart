// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

class SaisieManuelle extends StatelessWidget {
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  final MigAction migaction;
  const SaisieManuelle({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

  static TextEditingController numdecctrl = TextEditingController();
  static TextEditingController macctlr = TextEditingController();
  static TextEditingController snctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (migaction.type == EnumMigAction.echange) {
      return _SaisieManuelleEchange(
        migaction: migaction,
        onSubmit: onSubmit,
      );
    }
    return _SaisieManuelleSimple(
      migaction: migaction,
      onSubmit: (param) => onSubmit(param, null),
    );
  }
}

class _SaisieManuelleSimple extends StatefulWidget {
  final Function(Equipement newEq) onSubmit;
  final bool modeEchange;

  final MigAction migaction;
  const _SaisieManuelleSimple({
    Key? key,
    required this.onSubmit,
    required this.migaction,
    this.modeEchange = false,
  }) : super(key: key);

  @override
  State<_SaisieManuelleSimple> createState() => _SaisieManuelleSimpleState();
}

class _SaisieManuelleSimpleState extends State<_SaisieManuelleSimple> {
  Equipement? currentEquipement;
  bool submited = false;
  DeviceBarCodes? get currentScannedCode =>
      ScaffoldTabs.of(context)?.currentScannedCode;


    validate() {
      var eq = Equipement(
          numdec: SaisieManuelle.numdecctrl.text,
          numeroSerie: SaisieManuelle.snctrl.text,
          adresseMAC: SaisieManuelle.macctlr.text,
          typeEquipement: widget.migaction.typeEquipement);
      widget.onSubmit(eq);
      setState(() {
        currentEquipement = eq;
        if (widget.modeEchange == false) {
          submited = true;
        } else {
          EchangeEquipementSwitcher.setCurrentEquipement = eq;
        }
      });

      closeKeyboard(context);
    }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Saisie Manuelle",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Focus(
            child: TextFormField(
              autofocus: true,
              controller: SaisieManuelle.numdecctrl,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  EchangeEquipementSwitcher.update(numdec: value),
              decoration: const InputDecoration(
                  label: Text("Numdec"),
                  hintText: '123456789',
                  prefixIcon: Icon(Icons.onetwothree_outlined)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: SaisieManuelle.snctrl,
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                EchangeEquipementSwitcher.update(numeroSerie: value),
            decoration: const InputDecoration(
                label: Text("N° de Série"),
                hintText: "N123456789",
                prefixIcon: Icon(Icons.qr_code_2_sharp)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: SaisieManuelle.macctlr,
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                EchangeEquipementSwitcher.update(adresseMAC: value),
            decoration: const InputDecoration(
                label: Text("Address MAC"),
                hintText: "0AB8C7F8G9",
                prefixIcon: Icon(Icons.abc_sharp)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              ElevatedButton(onPressed: validate, child: const Text("Valider")),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.modeEchange
              ? (currentEquipement != null ? 1 : 0)
              : (submited ? 1 : 0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(widget.migaction.tache),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Numdec :"),
                        Text(currentEquipement?.numdec ?? "")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("N° Série :"),
                        Text(currentEquipement?.numeroSerie ?? "")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Addresse MAC :"),
                        Text(currentEquipement?.adresseMAC ?? "")
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class _SaisieManuelleEchange extends StatefulWidget {
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  final MigAction migaction;
  const _SaisieManuelleEchange({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

  @override
  State<_SaisieManuelleEchange> createState() => _SaisieManuelleEchangeState();
}

class _SaisieManuelleEchangeState extends State<_SaisieManuelleEchange> {
  Equipement? nouvelEquipement;
  Equipement? ancienEquipement;
  Equipement? currentEquipement;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EchangeEquipementSwitcher(
          onSwitch: (equipement) {
            SaisieManuelle.macctlr.text = equipement?.adresseMAC ?? "";
            SaisieManuelle.snctrl.text = equipement?.numeroSerie ?? "";
            SaisieManuelle.numdecctrl.text = equipement?.numdec ?? "";
            setState(() {
              currentEquipement = equipement;
            });
          },
        ),
        _SaisieManuelleSimple(
            currentEquipement: currentEquipement,
            modeEchange: true,
            onSubmit: (equipement) {
              setState(() {
                if (EchangeEquipementSwitcher.isNewer) {
                  nouvelEquipement = equipement;
                } else {
                  ancienEquipement = equipement;
                }
              });
              widget.onSubmit(nouvelEquipement, ancienEquipement);
            },
            migaction: widget.migaction)
      ],
    );
  }
}
