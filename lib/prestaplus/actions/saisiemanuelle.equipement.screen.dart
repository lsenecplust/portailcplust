// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';

class SaisieManuelle extends StatelessWidget {
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  final MigAction migaction;
  const SaisieManuelle({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

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

  final MigAction migaction;
  const _SaisieManuelleSimple({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

  @override
  State<_SaisieManuelleSimple> createState() => _SaisieManuelleSimpleState();
}

class _SaisieManuelleSimpleState extends State<_SaisieManuelleSimple> {
  var numdecctrl = TextEditingController();
  var macctlr = TextEditingController();
  var snctrl = TextEditingController();
  bool submited = false;
  @override
  Widget build(BuildContext context) {
    validate() {
      widget.onSubmit(Equipement(
          numdec: numdecctrl.text,
          numeroSerie: snctrl.text,
          adresseMAC: macctlr.text,
          type: widget.migaction.typeEquipement));
      setState(() {
        submited = true;
      });

      closeKeyboard(context);
    }

    ;
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
          child: TextFormField(
            controller: numdecctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: Text("Numdec"),
                hintText: '123456789',
                prefixIcon: Icon(Icons.onetwothree_outlined)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: snctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: Text("N° de Série"),
                hintText: "N123456789",
                prefixIcon: Icon(Icons.qr_code_2_sharp)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: macctlr,
            keyboardType: TextInputType.number,
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
          opacity: submited ? 1 : 0,
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
                      children: [const Text("Numdec :"), Text(numdecctrl.text)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const Text("N° Série :"), Text(snctrl.text)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Addresse MAC :"),
                        Text(macctlr.text)
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EchangeEquipementRecap(
          nouvelEquipement: nouvelEquipement,
          ancienEquipement: ancienEquipement,
        ),
        _SaisieManuelleSimple(
            onSubmit: (equipement) {
              var (pnouvelEquipement, pancienEquipement) =
                  EchangeEquipementRecap.affectEquipement(
                      equipement, nouvelEquipement, ancienEquipement);
              setState(() {
                nouvelEquipement = pnouvelEquipement;
                ancienEquipement = pancienEquipement;
              });
              widget.onSubmit(nouvelEquipement, ancienEquipement);
            },
            migaction: widget.migaction)
      ],
    );
  }
}
