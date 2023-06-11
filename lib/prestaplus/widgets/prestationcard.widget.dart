// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';

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
          builder: (BuildContext subcontext) {
            return SizedBox(
              width: double.infinity,
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      prestation.numPrestation,
                      style: Theme.of(subcontext).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: CustomFutureBuilder(
                        future: prestation.getActions(context),
                        progressIndicator: Column(children: [
                          const PortailIndicator(),
                          Text(
                            "Recherche des actions possibles...",
                            style: Theme.of(subcontext).textTheme.bodySmall,
                          ),
                        ]),
                        builder: (subcontext, snapshot) {
                          var actions = snapshot.data!;
                          if (actions.isEmpty) {
                            return const Column(
                              children: [
                                Icon(Icons.cancel, size: 50),
                                Text("Aucune action possible")
                              ],
                            );
                          }

                          return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.from(actions.map(
                                (e) => FilledButton.icon(
                                    onPressed: () => goto(e, context),
                                    icon: Icon(e.type!.icon),
                                    label: SizedBox(
                                        width: 200,
                                        child: Center(child: Text(e.tache)))),
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
        decoration: BoxDecoration(
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
                    style: const TextStyle(color: CustomColors.gray500),
                  ),
                  Text(
                    prestation.contactFullname,
                    style: const TextStyle(color: CustomColors.gray500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    prestation.clientNom,
                    style: TextStyle(color: lightColorScheme.primary),
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
    OAuthManager.of(context)?.navigatePush(
        context,
        RootContainer(
          title: action.tache,
          child:
              ActionEquipementScreen(prestation: prestation, migaction: action),
        ));
  }
}
