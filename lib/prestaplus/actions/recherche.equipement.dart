import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/echangeequipement.dart';

import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actions/action.equipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';

class RechercheEquipement extends StatefulWidget {
  final Prestation? prestation;
  final String? param;
  final Function(EchangeEquipment equipment)? onSelected;
  const RechercheEquipement({
    Key? key,
    this.prestation,
    this.param,
    this.onSelected,
  }) : super(key: key);

  @override
  State<RechercheEquipement> createState() => _RechercheEquipementState();
}

class _RechercheEquipementState extends State<RechercheEquipement> {
  late final searchcontroller =
      TextEditingController(text: widget.param ?? RechercheParam.param);
  late String? searchPattern = widget.param ?? RechercheParam.param;

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
