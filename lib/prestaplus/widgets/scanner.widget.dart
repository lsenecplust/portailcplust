import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/clientcard.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.detail.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/matrixscan.scandit.dart';

class BarCodeScanner extends StatefulWidget {
  final MigAction? migaction;
  final bool showClientCard;

  final ValueChanged<Equipement> onSelected;
  const BarCodeScanner({
    Key? key,
    this.migaction,
    this.showClientCard = false,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  Equipement? lastEquipmentQuery;
  DeviceBarCodes? lastScan;

  Widget get scanner => MatrixScanScreen(
        onScanned: (barcodes) {
          lastScan = barcodes;
          if (lastScan?.numdec != null) {
            setState(() {
              animatedChild = equipementfuture();
            });
          }
        },
      );
  late Widget animatedChild = scanner;

  Widget equipementfuture() => EquipementFuture(
        migaction: widget.migaction,
        future: Equipement.find(context, lastScan?.numdec),
        scannedbarcode: lastScan,
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
          EquipementDetail(equipement: lastEquipmentQuery),
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
          ),
          Visibility(
            visible: widget.showClientCard,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ClientCard(
                client: "SENE Lary",
              ),
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
