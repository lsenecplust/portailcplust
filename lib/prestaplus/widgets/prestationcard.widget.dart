import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/main.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/cpe/affectation.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/cpe/restitution.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/ont/affectation.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/ont/restitution.dart';

class PrestationCard extends StatelessWidget {
  final Prestation prestation;
  const PrestationCard({
    Key? key,
    required this.prestation,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(prestation.numPrestation,style: Theme.of(context).textTheme.headline4,),
                    ),
                    Wrap(
                      spacing: 5.0,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () => gotoAffectationCPE(context),
                            icon: const Icon(Icons.router),
                            label: const Text("Affectation CPE")),
                        ElevatedButton.icon(
                            onPressed: () => gotoRestitutionCPE(context),
                            icon: const Icon(Icons.switch_access_shortcut_outlined),
                            label: const Text("Restitution CPE")),
                        ElevatedButton.icon(
                            onPressed: () => gotoAffectationONT(context),
                            icon: const Icon(Icons.router),
                            label: const Text("Affectation ONT")),
                        ElevatedButton.icon(
                            onPressed: () => gotoRestitutionONT(context),
                            icon: const Icon(Icons.switch_access_shortcut_outlined),
                            label: const Text("Restitution ONT")),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          boxShadow: [
            BoxShadow(
                color: CustomColors.pink,
                offset: Offset(-7, 0),
                blurRadius: 0,
                spreadRadius: 0),
            BoxShadow(
                color: CustomColors.gray400,
                offset: Offset(2, 2),
                blurRadius: 2,
                spreadRadius: 2.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${prestation.numPrestation} ",
                  ),
                  Text(
                    DateFormat('EEEE d MMM HH:mm').format(prestation.dateRdv),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      prestation.contactFullname,
                      style: const TextStyle(color: CustomColors.gray500),
                    ),
                    Text(
                      prestation.clientNom,
                      style: const TextStyle(color: CustomColors.pink),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void gotoAffectationCPE(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootContainer(
                  title: "Affectation CPE",
                  child: AffectationCPE(prestation: prestation),
                )));
  }

  gotoRestitutionCPE(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootContainer(
                  title: "Restitution CPE",
                  child: RestitutionCPE(prestation: prestation),
                )));
  }

  gotoAffectationONT(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootContainer(
                  title: "Affectation ONT",
                  child: AffectationONT(prestation: prestation),
                )));
  }

  gotoRestitutionONT(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootContainer(
                  title: "Restitution ONT",
                  child: RestitutionONT(prestation: prestation),
                )));
  }
}
