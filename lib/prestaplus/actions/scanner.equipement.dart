import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';

class ScannerEquipement extends StatelessWidget {
  final Prestation? prestation;
  final Function(String? param)? onSelected;

  const ScannerEquipement({
    Key? key,
    this.prestation,
    this.onSelected,
  }) : super(key: key);

  List<Widget> buildItems(BuildContext context) {
    List<Widget> listItem = List.empty(growable: true);
    if (prestation != null) {
      listItem.addAll([
        Text(
          "Prestation",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrestationCard(prestation: prestation!),
        ),
      ]);
    }

    listItem.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: BarCodeScanner(
            onDetect: (value) async {
              debugPrint(
                  "▌│█║▌║▌║scanned : ${value.barcodes.map((e) => e.rawValue).join()}");

              var param = value.barcodes.first.rawValue;
              if (param != null) onSelected?.call(param);
            },
          ),
        );
      }),
    ));

    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildItems(context),
    );
  }
}
