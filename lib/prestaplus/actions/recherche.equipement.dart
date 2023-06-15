import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/echange.equipement.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';

class RechercheManuelle extends StatelessWidget {
  final Prestation? prestation;
  final MigAction migaction;
  final String? param;
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
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
      onSelected: (param) => onSubmit(param, null),
    );
  }
}

class RechercheEquipementSimple extends StatefulWidget {
  final Prestation? prestation;
  final Function(EquipementQuery equipment)? onSelected;
  const RechercheEquipementSimple({
    Key? key,
    this.prestation,
    this.onSelected,
  }) : super(key: key);

  @override
  State<RechercheEquipementSimple> createState() =>
      _RechercheEquipementSimpleState();
}

class _RechercheEquipementSimpleState extends State<RechercheEquipementSimple> {
  final searchcontroller = TextEditingController();
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
          onFieldSubmitted: (value) {
            setState(() {
              searchPattern = value;
            });
          },
          decoration: const InputDecoration(
              label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
        ),
      ),
      Expanded(
        child: EquipementFuture(
          onSelectedequipment: widget.onSelected,
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
  final Function(EquipementQuery? newEq, EquipementQuery? oldEq) onSubmit;
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
        Expanded(
          child: RechercheEquipementSimple(onSelected: (equipement) {
            var (pnouvelEquipement, pancienEquipement) =
                EchangeEquipementRecap.affectEquipement(
                    equipement, nouvelEquipement, ancienEquipement);
            setState(() {
              nouvelEquipement = pnouvelEquipement;
              ancienEquipement = pancienEquipement;
            });
            widget.onSubmit(nouvelEquipement, ancienEquipement);
          }),
        )
      ],
    );
  }
}
