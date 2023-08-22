import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

enum SelectedEquipement { older, newer }

class EchangeEquipementSwitcher extends StatefulWidget {
  final Function(Equipement? equipment) onSwitch;
  static Equipement? nouvelEquipement;
  static Equipement? ancienEquipement;
  static SelectedEquipement selectedEquipement = SelectedEquipement.newer;

  static bool get isNewer => selectedEquipement == SelectedEquipement.newer;
  static bool get isOlder => !isNewer;

  static updateolder(
      {String? numdec, String? numeroSerie, String? adresseMAC}) {
    ancienEquipement ??= Equipement();
    ancienEquipement = ancienEquipement?.copyWith(
        numdec: numdec, numeroSerie: numeroSerie, adresseMAC: adresseMAC);
  }

  static updatenewer(
      {String? numdec, String? numeroSerie, String? adresseMAC}) {
    nouvelEquipement ??= Equipement();
    nouvelEquipement = nouvelEquipement?.copyWith(
        numdec: numdec, numeroSerie: numeroSerie, adresseMAC: adresseMAC);
  }

  static update({String? numdec, String? numeroSerie, String? adresseMAC}) {
    if (isNewer) {
      updatenewer(
          numdec: numdec, numeroSerie: numeroSerie, adresseMAC: adresseMAC);
    } else {
      updateolder(
          numdec: numdec, numeroSerie: numeroSerie, adresseMAC: adresseMAC);
    }
  }

  const EchangeEquipementSwitcher({
    Key? key,
    required this.onSwitch,
  }) : super(key: key);

  @override
  State<EchangeEquipementSwitcher> createState() =>
      _EchangeEquipementSwitcherState();
}

class _EchangeEquipementSwitcherState extends State<EchangeEquipementSwitcher> {
  late SelectedEquipement selectedEquipement =
      EchangeEquipementSwitcher.selectedEquipement;

  nouvelEquipementOnTap() {
    if (mounted) {
      setState(() {
        selectedEquipement = SelectedEquipement.newer;
        EchangeEquipementSwitcher.selectedEquipement = selectedEquipement;
      });
      widget.onSwitch(EchangeEquipementSwitcher.nouvelEquipement);
    }
  }

  ancienEquipementOnTap() {
    if (mounted) {
      setState(() {
        selectedEquipement = SelectedEquipement.older;
        EchangeEquipementSwitcher.selectedEquipement = selectedEquipement;
      });
      widget.onSwitch(EchangeEquipementSwitcher.ancienEquipement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NouvelEquipementRecap(
            equipement: EchangeEquipementSwitcher.nouvelEquipement,
            ontap: nouvelEquipementOnTap,
            selectedEquipement: selectedEquipement),
        Icon(
          Icons.swap_horiz_outlined,
          size: 60,
          color: lightColorScheme.primary,
        ),
        _AncienEquipementRecap(
            equipement: EchangeEquipementSwitcher.ancienEquipement,
            ontap: ancienEquipementOnTap,
            selectedEquipement: selectedEquipement),
      ],
    );
  }
}

class EquipementRecap extends StatelessWidget {
  final String title;
  final String? numdec;
  final bool isSelected;
  final Function()? ontap;

  const EquipementRecap({
    Key? key,
    required this.title,
    this.numdec,
    required this.isSelected,
    this.ontap,
  }) : super(key: key);

  bool get isNumdecNull => numdec == null;
  Color get backgroundColor =>
      isNumdecNull ? CustomColors.gray200 : lightColorScheme.primaryContainer;
  double get circleSize => isNumdecNull ? 0 : 30;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 100,
              width: 140,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: isSelected
                      ? Border.all(width: 3, color: lightColorScheme.primary)
                      : Border.all(width: 0, color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title),
                  Icon(
                    Icons.router,
                    size: 45,
                    color: lightColorScheme.outline,
                  ),
                  Text(
                    numdec ?? "----------------",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                  color: CustomColors.green,
                  borderRadius:
                      BorderRadius.all(Radius.circular(circleSize / 2))),
              child: isNumdecNull
                  ? null
                  : const Icon(Icons.check_rounded, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _NouvelEquipementRecap extends StatelessWidget {
  final Equipement? equipement;
  final SelectedEquipement selectedEquipement;
  final Function()? ontap;

  const _NouvelEquipementRecap({
    Key? key,
    this.equipement,
    required this.selectedEquipement,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      title: "Nouveau",
      ontap: ontap,
      isSelected: selectedEquipement == SelectedEquipement.newer,
      numdec: equipement?.getnumdec,
    );
  }
}

class _AncienEquipementRecap extends StatelessWidget {
  final Equipement? equipement;
  final SelectedEquipement selectedEquipement;
  final Function()? ontap;

  const _AncienEquipementRecap({
    Key? key,
    this.equipement,
    required this.selectedEquipement,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      ontap: ontap,
      title: "Ancien",
      isSelected: selectedEquipement == SelectedEquipement.older,
      numdec: equipement?.getnumdec,
    );
  }
}
