import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/main.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/cpe/affectation.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/cpe/restitution.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/ont/affectation.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/ont/restitution.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class PrestaplusScreen extends StatelessWidget {
  const PrestaplusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: Prestation.get,
      builder: (context, snapshot) {
        return PresationList(
          prestations: snapshot.data!,
        );
      },
    );
  }
}

class PresationList extends StatefulWidget {
  final List<Prestation> prestations;
  const PresationList({
    Key? key,
    required this.prestations,
  }) : super(key: key);

  @override
  State<PresationList> createState() => _PresationListState();
}

class _PresationListState extends State<PresationList> {
  Prestation? selectedPrestation;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.from(widget.prestations.map((e) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: _PrestationCard(
              prestation: e,
              selectedPrestation: selectedPrestation,
              onSelected: (prestation) {
                setState(() {
                  selectedPrestation = prestation;
                });
              },
            ),
          ))),
    );
  }
}

class _PrestationCard extends StatelessWidget {
  final Prestation prestation;
  final Prestation? selectedPrestation;
  final Function(Prestation prestation) onSelected;
  const _PrestationCard({
    Key? key,
    required this.prestation,
    this.selectedPrestation,
    required this.onSelected,
  }) : super(key: key);

  bool get isSelected => prestation == selectedPrestation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(prestation),
      child: Card(
        elevation: 15,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.calendar_month, color: CustomColors.gray500),
                Text(
                  "${prestation.idPrestation} ",
                ),
                Text(
                  DateFormat('EEE d MMM HH:mm',
                          Localizations.localeOf(context).languageCode)
                      .format(prestation.daterendezvous),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(color: CustomColors.gray500),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(prestation.client),
                        Text(prestation.adresse),
                        Text("${prestation.codepostale} ${prestation.ville}"),
                      ]),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isSelected
                  ? Wrap(
                      spacing: 5.0,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () => gotoAffectationCPE(context),
                            icon: const Icon(Icons.router),
                            label: const Text("Affectation CPE")),
                        ElevatedButton.icon(
                            onPressed: () => gotoRestitutionCPE(context),
                            icon: const Icon(
                                Icons.switch_access_shortcut_outlined),
                            label: const Text("Restitution CPE")),
                        ElevatedButton.icon(
                            onPressed: () => gotoAffectationONT(context),
                            icon: const Icon(Icons.router),
                            label: const Text("Affectation ONT")),
                        ElevatedButton.icon(
                            onPressed: () => gotoRestitutionONT(context),
                            icon: const Icon(
                                Icons.switch_access_shortcut_outlined),
                            label: const Text("Restitution ONT")),
                      ],
                    )
                  : null,
            )
          ],
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
