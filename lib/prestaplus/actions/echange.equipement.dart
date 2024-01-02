import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';

class EchangeEquipementSwitcher extends StatefulWidget {
    final void Function(Equipement? equipment)? onswitch;

  const EchangeEquipementSwitcher({
    super.key,
    this.onswitch,
  });

  @override
  State<EchangeEquipementSwitcher> createState() =>
      _EchangeEquipementSwitcherState();
}

class _EchangeEquipementSwitcherState extends State<EchangeEquipementSwitcher> {
  nouvelEquipementOnTap() {
    if(mounted){
    setState(() {
      context.selectedEquipement = SelectedEquipement.newer;
    });
    widget.onswitch?.call(context.exchangeEquipementController?.getCurrentEquipement);
    }
  }

  ancienEquipementOnTap() {
    if(mounted) {
    setState(() {
      context.selectedEquipement = SelectedEquipement.older;
    });
    widget.onswitch?.call(context.exchangeEquipementController?.getCurrentEquipement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NouvelEquipementRecap(ontap: nouvelEquipementOnTap),
        Icon(
          Icons.swap_horiz_outlined,
          size: 60,
          color: lightColorScheme.primary,
        ),
        _AncienEquipementRecap(ontap: ancienEquipementOnTap),
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
    super.key,
    required this.title,
    this.numdec,
    required this.isSelected,
    this.ontap,
  });

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
  final Function()? ontap;

  const _NouvelEquipementRecap({
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      title: "Nouveau",
      ontap: ontap,
      isSelected: context.selectedEquipement == SelectedEquipement.newer,
      numdec: context.equipementValidated?.newerEquipement?.getnumdec,
    );
  }
}

class _AncienEquipementRecap extends StatelessWidget {
  final Function()? ontap;

  const _AncienEquipementRecap({
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return EquipementRecap(
      ontap: ontap,
      title: "Ancien",
      isSelected: context.selectedEquipement == SelectedEquipement.older,
      numdec: context.equipementValidated?.olderEquipement?.getnumdec,
    );
  }
}
