import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipementcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class ActionEquipementScreen extends StatefulWidget {
  final Prestation prestation;
  final MigAction migaction;
  const ActionEquipementScreen({
    Key? key,
    required this.prestation,
    required this.migaction,
  }) : super(key: key);

  @override
  State<ActionEquipementScreen> createState() => _ActionEquipementScreenState();
}

class _ActionEquipementScreenState extends State<ActionEquipementScreen> {
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
              style: Theme.of(context).textTheme.headline4,
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
                affecter();
              },
              param: searchPattern,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> launchactionequipement() async {
    Random rnd;
    int min = 5;
    int max = 10;
    rnd = Random();

    switch (widget.migaction.tache) {
      case EnumMigAction.affectationONT:
        return Future.delayed(
                Duration(milliseconds: min + rnd.nextInt(max - min)))
            .then((value) => rnd.nextInt(max).isEven);
      // TODO: Handle affectationONT case.
      case EnumMigAction.affectationCPE:
        return Future.delayed(
                Duration(milliseconds: min + rnd.nextInt(max - min)))
            .then((value) => rnd.nextInt(max).isEven);
      // TODO: Handle affectationCPE case.
      case EnumMigAction.restitutionONT:
        return Future.delayed(
                Duration(milliseconds: min + rnd.nextInt(max - min)))
            .then((value) => rnd.nextInt(max).isEven);
      // TODO: Handle restitutionONT case.
      case EnumMigAction.restitutionCPE:
        return Future.delayed(
                Duration(milliseconds: min + rnd.nextInt(max - min)))
            .then((value) => rnd.nextInt(max).isEven);
      // TODO: Handle restitutionCPE case.
    }
  }

  void affecter() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: CircularProgressIndicator.adaptive(),
        );
      },
    );
    var actionok = await launchactionequipement();
    if (mounted) Navigator.pop(context);

    await AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      autoHide: const Duration(seconds: 2),
      dialogType: actionok ? DialogType.success : DialogType.error,
      showCloseIcon: true,
      title: actionok ? 'Succes' : 'Error',
      desc: '${widget.migaction.tache.displayName} Terminéee',
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

class SearchOrScanSwitch extends StatefulWidget {
  final ValueChanged<String?> onchange;
  const SearchOrScanSwitch({
    Key? key,
    required this.onchange,
  }) : super(key: key);

  @override
  State<SearchOrScanSwitch> createState() => _SearchOrScanSwitchState();
}

class _SearchOrScanSwitchState extends State<SearchOrScanSwitch> {
  bool scan = true;
  var circularRadius = BorderRadius.circular(10);
  var searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scanWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context,constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: 150,
            child: BarCodeScanner(
              onDetect: (value) => widget.onchange(value.rawValue),
            ),
          );
        }
      ),
    );

    var searchWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.caption!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Recherche équipement par :"),
                    Text("- num dec"),
                    Text("- num serie"),
                    Text("- adress mac"),
                  ],
                ),
              ),
            ),
          ),
          TextFormField(
            controller: searchcontroller,
            onFieldSubmitted: (s) => widget.onchange(s),
            decoration: const InputDecoration(
                label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
          ),
        ],
      ),
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: CustomColors.gray300,
            borderRadius: circularRadius,
          ),
          child: ToggleButtons(
            isSelected: [scan, !scan],
            onPressed: (index) {
              setState(() {
                scan = !scan;
              });
            },
            borderRadius: circularRadius,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Scanner équipement',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Rechercher équipement'),
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: scan ? scanWidget : searchWidget,
        )
      ],
    );
  }
}

class EquipementFuture extends StatelessWidget {
  final String? param;
  final MigAction? migaction;
  final ValueChanged<Equipement?>? action;
  final ValueChanged<Equipement?>? onselectedequipment;
  const EquipementFuture(
      {super.key,
      required this.param,
      this.action,
      this.migaction,
      this.onselectedequipment});

  @override
  Widget build(BuildContext context) {
    Equipement? equipmentSelected;
    if (param?.isEmpty ?? true) {
      return Container();
    }
    return CustomFutureBuilder(
      future: Equipement.get(context, param!),
      builder: (context, snapshot) {
        var equipements = snapshot.data!;
        if (equipements.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Icon(Icons.no_cell_rounded),
                  Text("Aucun équipement trouvée"),
                ],
              ),
            ),
          );
        }

        if (equipements.length == 1) equipmentSelected = equipements.first;

        return ListView(
          shrinkWrap: true,
          children: [
            ...equipements.map((e) => EquipementCard(
                  equipement: e,
                  ontap: (equipement) {
                    equipmentSelected = equipement;
                    onselectedequipment?.call(equipement);
                  },
                )),
            ...[
              Visibility(
                visible: migaction != null,
                child: Center(
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.ads_click_sharp),
                      onPressed: () => action?.call(equipmentSelected),
                      label: Text(migaction?.tache.displayName ?? "")),
                ),
              )
            ]
          ],
        );
      },
    );
  }
}
