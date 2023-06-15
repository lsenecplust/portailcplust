import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:portail_canalplustelecom_mobile/class/equipementquery.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.detail.widget.dart';

import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';

class BarCodeScanner extends StatefulWidget {
  final ValueChanged<EquipementQuery> onSelected;
  const BarCodeScanner({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  EquipementQuery? lastEquipmentQuery;
  String? lastparam;
  Widget get scanner => MobileScanner(
        key: ValueKey(DateTime.now().millisecondsSinceEpoch),
        fit: BoxFit.cover,
        onDetect: (barcode) {
          lastparam = barcode.barcodes.first.rawValue;
          debugPrint(
              "📷scanned : ${barcode.barcodes.map((e) => e.rawValue).join()}");
          if (lastparam != null) {
            setState(() {
              animatedChild = equipementfuture();
            });
          }
        },
      );

  late Widget animatedChild = scanner;

  Widget equipementfuture() => EquipementFuture(
        param: lastparam,
        onSelectedequipment: (equipement) {
          widget.onSelected(equipement);
          lastEquipmentQuery = equipement;
          setState(() {
            animatedChild = detailView;
          });
        },
      );

  Widget get detailView => Column(
        children: [
          EquipementDetail(equipement: lastEquipmentQuery?.equipement),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      animatedChild = equipementfuture();
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Retour"),
                ),
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      animatedChild = scanner;
                    });
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Scan"),
                )
              ],
            ),
          )
        ],
      );
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: animatedChild,
    );
  }
}
