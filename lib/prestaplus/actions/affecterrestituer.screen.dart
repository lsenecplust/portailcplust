import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/searchorscan.widget.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';

class AffecterRestituer extends StatefulWidget {
  final Prestation prestation;
  final MigAction migaction;
  final Function() action;
  const AffecterRestituer({
    Key? key,
    required this.prestation,
    required this.migaction,
    required this.action,
  }) : super(key: key);

  @override
  State<AffecterRestituer> createState() => _AffecterRestituerState();
}

class _AffecterRestituerState extends State<AffecterRestituer> {
  String? searchPattern;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Prestation",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrestationCard(prestation: widget.prestation),
            ),
            SearchOrScanSwitch(
              onchange: (value) {
                setState(() {
                  searchPattern = value;
                });
              },
            ),
            EquipementFuture(
              migaction: widget.migaction,
              action: (value) {
                actionDialog();
              },
              param: searchPattern,
            ),
          ],
        ),
      ),
    );
  }

  void actionDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: PortailIndicator(),
        );
      },
    );
    var actionok = await widget.action();
    if (mounted) {
      Navigator.pop(context);
      await AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        autoHide: const Duration(seconds: 2),
        dialogType: actionok ? DialogType.success : DialogType.error,
        showCloseIcon: true,
        title: actionok ? 'Succes' : 'Error',
        desc: '${widget.migaction.tache} Terminéee',
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          if (actionok) {
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return const RootContainer();
            })));
          }
        },
      ).show();
    }
  }


}
