// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';

class SaisieManuelle extends StatelessWidget {
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
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
  final Function(EquipementQuery newEq) onSubmit;
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
  var controller = TextEditingController();
  var focus = FocusNode();
  bool submited = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Saisissez le numdec",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            focusNode: focus,
            autofocus: false,
            onFieldSubmitted: (value) {
              widget.onSubmit(EquipementQuery(numdec: value));
              setState(() {
                submited = true;
              });
            },
            decoration: const InputDecoration(
                label: Text("Saisissez le numdec"),
                prefixIcon: Icon(Icons.qr_code_2_sharp)),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: submited ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("${widget.migaction.tache} de ${controller.text}"),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _SaisieManuelleEchange extends StatefulWidget {
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
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
  EquipementQuery? nouvelEquipement;
  EquipementQuery? ancienEquipement;
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
