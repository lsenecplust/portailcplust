import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/main.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/widgets/barcode_scanner_controller.dart';

class RestitutionONT extends StatefulWidget {
  final Prestation prestation;
  const RestitutionONT({
    Key? key,
    required this.prestation,
  }) : super(key: key);

  @override
  State<RestitutionONT> createState() => _RestitutionONTState();
}

class _RestitutionONTState extends State<RestitutionONT> {
  bool isdetected = false;
  bool isScanning = false;
  bool isLoading = false;
  Duration duration = const Duration(milliseconds: 500);
  var serialnumber = TextEditingController();
  var serialNode = FocusNode();
  var macNode = FocusNode();
  var macadrress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton.icon(
                onPressed: toogleScanner,
                icon: const Icon(Icons.qr_code),
                label: const Text("Scanner")),
            AnimatedContainer(
              duration: duration,
              height: isScanning ? 300 : 0,
              width: double.infinity,
              child: Builder(builder: (context) {
                if (isScanning == false) return Container();
                if (isLoading == true) return Container();

                return BarCodeScanner(
                  onDetect: onDetect,
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: CustomColors.pink,
                      thickness: 5.0,
                    ),
                  )),
                  Text(
                    "ou",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: CustomColors.pink,
                      thickness: 5.0,
                    ),
                  )),
                ],
              ),
            ),
            TextFormField(
              focusNode: serialNode,
              controller: serialnumber,
              decoration: const InputDecoration(label: Text("Numdec")),
            ),
            ElevatedButton(onPressed: affecter, child: const Text("Affecter"))
          ],
        ),
      ),
    );
  }

  void toogleScanner() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isScanning = !isScanning;
      isLoading = true;
    });
    Future.delayed(duration).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void onDetect(Barcode value) {
    toogleScanner();

    if (serialnumber.text.isEmpty || serialNode.hasFocus) {
      serialnumber.text = value.rawValue ?? "";
      return;
    }
    if (macadrress.text.isEmpty || macNode.hasFocus) {
      macadrress.text = value.rawValue ?? "";
    }
  }

  void affecter() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      autoHide: const Duration(seconds: 2),
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: 'Restitution Terminéee',
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        Navigator.push(context, MaterialPageRoute(builder:((context) {
          return const RootContainer();
        })));
      },
    ).show();
  }
}
