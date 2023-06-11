// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/actionequipement.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

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
              width: double.infinity,
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      prestation.numPrestation,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: CustomFutureBuilder(
                        future: prestation.getAllActions(context),
                        progressIndicator: Column(children: [
                          const PortailIndicator(),
                          Text(
                            "Recherche des actions possibles...",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ]),
                        builder: (context, snapshot) {
                          var actions = snapshot.data!;
                          if (actions.isEmpty) {
                            return const Column(
                              children: [
                                Icon(Icons.cancel, size: 50),
                                Text("Aucune action possible")
                              ],
                            );
                          }

                          return Wrap(
                              spacing: 5.0,
                              children: List.from(actions.map(
                                (e) => ElevatedButton.icon(
                                    onPressed: () => goto(e, context),
                                    icon: Icon(e.tache.icon),
                                    label: Text(e.tache.displayName)),
                              )));
                        }),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          boxShadow: [
            BoxShadow(
                color: lightColorScheme.primary,
                offset: const Offset(-7, 0),
                blurRadius: 0,
                spreadRadius: 0),
            const BoxShadow(
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
                    DateFormat('EEE d MMM yyyy - HH:mm')
                        .format(prestation.dateRdv),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prestation.idRdvPxo,
                    style:  const TextStyle(color: CustomColors.gray500),
                  ),
                  Text(
                    prestation.contactFullname,
                    style:  const TextStyle(color: CustomColors.gray500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    prestation.clientNom,
                    style:  TextStyle(color: lightColorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goto(MigAction action, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootContainer(
                  title: action.tache.displayName,
                  child: ActionEquipementScreen(
                      prestation: prestation, migaction: action),
                )));
  }
}
