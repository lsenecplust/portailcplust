import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';

class RechercheManuelle extends StatelessWidget {
  final Prestation? prestation;
  final MigAction migaction;
  final String? param;
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  const RechercheManuelle({
    Key? key,
    this.prestation,
    required this.migaction,
    this.param,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (migaction.type == EnumMigAction.echange) {
      return _RechercheEquipementEchange(
        migaction: migaction,
        onSubmit: onSubmit,
      );
    }
    return RechercheEquipementSimple(
      migaction: migaction,
      onSelected: (param) => onSubmit(param, null),
    );
  }
}

class RechercheEquipementSimple extends StatefulWidget {
  final Prestation? prestation;
  final MigAction migaction;
  final bool modeEchange;
  final Function(Equipement equipment)? onSelected;
  const RechercheEquipementSimple({
    Key? key,
    this.prestation,
    required this.migaction,
    this.onSelected,
    this.modeEchange = false,
  }) : super(key: key);

  @override
  State<RechercheEquipementSimple> createState() =>
      _RechercheEquipementSimpleState();
}

class _RechercheEquipementSimpleState extends State<RechercheEquipementSimple> {
  final searchcontroller = TextEditingController();
  late Future<List<Equipement>> futureEquipement =
      Equipement.get(context, null);
  String? searchPattern;

  List<Widget> buildItems(BuildContext context) {
    List<Widget> listItem = List.empty(growable: true);
    if (widget.prestation != null) {
      listItem.addAll([
        Text(
          "Prestation",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrestationCard(prestation: widget.prestation!),
        ),
      ]);
    }

    listItem.addAll([
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: searchPattern == null ? 100 : 0,
        child: Card(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recherche équipement par :"),
                  Text("- num dec"),
                  Text("- num serie"),
                  Text("- adress mac"),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: searchcontroller,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            setState(() {
              searchPattern = value;
              futureEquipement = Equipement.get(context, searchPattern);
            });
          },
          decoration: const InputDecoration(
              label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
        ),
      ),
      Expanded(
        child: EquipementFuture(
          migaction: widget.migaction,
          modeEchange: widget.modeEchange,
          onSelectedequipment: widget.onSelected,
          future: futureEquipement,
          param: searchPattern,
        ),
      ),
    ]);

    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: buildItems(context),
    );
  }
}

class _RechercheEquipementEchange extends StatefulWidget {
  final Function(Equipement? newEq, Equipement? oldEq) onSubmit;
  final MigAction migaction;
  const _RechercheEquipementEchange({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

  @override
  State<_RechercheEquipementEchange> createState() =>
      _RechercheEquipementEchangeState();
}

class _RechercheEquipementEchangeState
    extends State<_RechercheEquipementEchange> {
  Equipement? currentEquipement;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EchangeEquipementSwitcher(
          onswitch: (equipement) => setState(() {
            currentEquipement = equipement;
          }),
        ),
        Expanded(
          child: RechercheEquipementSimple(
              migaction: widget.migaction,
              modeEchange: true,
              onSelected: (equipement) {
                setState(() {});
                context.exchangeEquipementController?.setValidatedEquipement =
                    equipement.copyWith(
                        typeEquipement: widget.migaction.typeEquipement);
                widget.onSubmit(context.equipementValidated?.newerEquipement,
                    context.equipementValidated?.olderEquipement);
              }),
        )
      ],
    );
  }
}
