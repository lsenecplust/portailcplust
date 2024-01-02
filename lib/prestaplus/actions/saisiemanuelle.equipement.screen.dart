import 'package:flutter/material.dart';
import 'package:librairies/form_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';

class SaisieManuelle extends StatelessWidget {
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  final MigAction migaction;
  const SaisieManuelle({
    super.key,
    required this.onSubmit,
    required this.migaction,
  });

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
  final Equipement? currentEquipement;
  final bool modeEchange;

  final MigAction migaction;
  const _SaisieManuelleSimple({
    super.key,
    required this.onSubmit,
    this.currentEquipement,
    this.modeEchange = false,
    required this.migaction,
  });

  @override
  State<_SaisieManuelleSimple> createState() => _SaisieManuelleSimpleState();
}

class _SaisieManuelleSimpleState extends State<_SaisieManuelleSimple> {
  late Equipement? currentEquipement = widget.currentEquipement;
  bool submited = false;
  final _formKey = GlobalKey<FormState>();

  final macmask = MaskTextInputFormatter(
      mask: '##:##:##:##:##:##',
      filter: {"#": RegExp(r'[0-9A-Fa-f]')},
      type: MaskAutoCompletionType.eager);

  final numeroSeriemask = MaskTextInputFormatter(
      mask: 'N##############',
      filter: {"#": RegExp(r'[0-9]*')},
      type: MaskAutoCompletionType.eager);

  TextEditingController numdecctrl = TextEditingController();
  TextEditingController adresseMACctlr = TextEditingController();
  TextEditingController numeroSeriectrl = TextEditingController();

  validate() {
    if (_formKey.currentState!.validate() == false) return;

    var eq = Equipement(
        numdec: numdecctrl.text,
        numeroSerie: numeroSeriectrl.text,
        adresseMAC: adresseMACctlr.text,
        typeEquipement: widget.migaction.typeEquipement);
    context.exchangeEquipementController?.setCurrentEquipement = eq;
    context.exchangeEquipementController?.setValidatedEquipement = eq;
    widget.onSubmit(eq);

    if (widget.modeEchange == false) {
      setState(() {
        submited = true;
      });
    }

    closeKeyboard(context);
  }

  initFields() {
    currentEquipement =
        context.exchangeEquipementController?.getCurrentEquipement ??
            widget.currentEquipement;

    String? numeroSerie;
    String? numdec;
    String? adresseMAC;

    var lastscan = context.exchangeEquipementController?.lastScan;

    if (lastscan == null) {
      numdec = currentEquipement?.numdec;
      adresseMAC = currentEquipement?.adresseMAC;
      numeroSerie = currentEquipement?.numeroSerie;
    } else {
      numdec = lastscan.numdec;
      numeroSerie = numeroSeriemask
          .maskText(lastscan.numeroSerie?.replaceAll("N", "") ?? "");
      adresseMAC = macmask.maskText(lastscan.adresseMAC ?? "");
    }

    numdecctrl.text = numdec ?? "";
    adresseMACctlr.text = adresseMAC ?? "";
    numeroSeriectrl.text = numeroSerie ?? "";

    context.exchangeEquipementController?.lastScan = null;
  }

  @override
  Widget build(BuildContext context) {
    initFields();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
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
            child: TextFormField(
              controller: numdecctrl,
              maxLength: 12,
              validator: ValidationBuilder()
                  .required("Le Numdec est obligatoire")
                  .build(),
              keyboardType: TextInputType.number,
              onChanged: (value) => context.exchangeEquipementController
                  ?.updateCurrent(numdec: value),
              decoration: const InputDecoration(
                  label: Text("Numdec"),
                  hintText: '123456789',
                  prefixIcon: Icon(Icons.onetwothree_outlined)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              inputFormatters: [numeroSeriemask],
              controller: numeroSeriectrl,
              maxLength: 15,
              keyboardType: TextInputType.number,
              onChanged: (value) => context.exchangeEquipementController
                  ?.updateCurrent(numeroSerie: value),
              decoration: const InputDecoration(
                  label: Text("N° de Série"),
                  hintText: "N123456789",
                  prefixIcon: Icon(Icons.qr_code_2_sharp)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: adresseMACctlr,
              maxLength: 17,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [macmask],
              validator: ValidationBuilder(optional: true)
                  .addresseMac("L'adresse MAC est incorrecte")
                  .build(),
              onChanged: (value) => context.exchangeEquipementController
                  ?.updateCurrent(addressMac: value),
              decoration: const InputDecoration(
                  label: Text("Address MAC"),
                  hintText: "0A:B8:C7:F8:G9:12",
                  prefixIcon: Icon(Icons.abc_sharp)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: validate, child: const Text("Valider")),
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
      ),
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
    super.key,
    required this.onSubmit,
    required this.migaction,
  });

  @override
  State<_SaisieManuelleEchange> createState() => _SaisieManuelleEchangeState();
}

class _SaisieManuelleEchangeState extends State<_SaisieManuelleEchange> {
  Equipement? currentEquipement;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EchangeEquipementSwitcher(
            onswitch: (equipement) => setState(() {
              currentEquipement = equipement;
            }),
          ),
          _SaisieManuelleSimple(
              currentEquipement: currentEquipement,
              modeEchange: true,
              onSubmit: (equipement) {
                setState(() {});
                widget.onSubmit(context.equipementValidated?.newerEquipement,
                    context.equipementValidated?.olderEquipement);
              },
              migaction: widget.migaction)
        ],
      ),
    );
  }
}
