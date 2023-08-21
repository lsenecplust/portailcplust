import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EchangeEquipementRecap extends StatelessWidget {
  final Equipement? nouvelEquipement;
  final Equipement? ancienEquipement;
  const EchangeEquipementRecap({
    Key? key,
    this.nouvelEquipement,
    this.ancienEquipement,
  }) : super(key: key);

  static (Equipement?, Equipement?) affectEquipement(Equipement? equipement,
      Equipement? nouvelEquipement, Equipement? ancienEquipement) {
    if (nouvelEquipement != null && ancienEquipement != null) {
      nouvelEquipement = ancienEquipement = null;
      nouvelEquipement = equipement;
      return (nouvelEquipement, ancienEquipement);
    }
    if (nouvelEquipement != null) {
      ancienEquipement = equipement;
      return (nouvelEquipement, ancienEquipement);
    }
    nouvelEquipement = equipement;
    return (nouvelEquipement, ancienEquipement);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NouvelEquipementRecap(
          equipement: nouvelEquipement,
        ),
        Icon(
          Icons.swap_horiz_outlined,
          size: 60,
          color: lightColorScheme.primary,
        ),
        _AncienEquipementRecap(equipement: ancienEquipement),
      ],
    );
  }
}

class EquipementRecap extends StatelessWidget {
  final String title;
  final String? numdec;

  const EquipementRecap({
    Key? key,
    required this.title,
    this.numdec,
  }) : super(key: key);

  bool get isNumdecNull => numdec == null;
  Color get backgroundColor =>
      isNumdecNull ? CustomColors.gray200 : lightColorScheme.primaryContainer;
  double get circleSize => isNumdecNull ? 0 : 30;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 100,
            width: 140,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

class _NouvelEquipementRecap extends StatelessWidget {
  final Equipement? equipement;

  const _NouvelEquipementRecap({
    Key? key,
    this.equipement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      title: "Nouveau",
      numdec: equipement?.getnumdec,
    );
  }
}

class _AncienEquipementRecap extends StatelessWidget {
  final Equipement? equipement;

  const _AncienEquipementRecap({
    Key? key,
    this.equipement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      title: "Ancien",
      numdec: equipement?.getnumdec,
    );
  }
}
