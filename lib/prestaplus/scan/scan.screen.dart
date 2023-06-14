import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/equipement.future.widget.dart';

class PrestaplusScanScreen extends StatefulWidget {
  const PrestaplusScanScreen({super.key});

  @override
  State<PrestaplusScanScreen> createState() => _PrestaplusScanScreenState();
}

class _PrestaplusScanScreenState extends State<PrestaplusScanScreen> {
  String? searchPattern;
  String? clientfound;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
         /* SearchOrScanSwitch(
            onchange: (value) {
              setState(() {
                searchPattern = value;
              //  print(value);
              });
            },
          ),*/
                //TODO : replace by new tabs separate swidgets
          EquipementFuture(
            onSelectedequipment: (_) {
              setState(() {
                //TODO : import client contrat search
                clientfound =
                    DateTime.now().second.isEven ? "RIBEIRO Dalila" : "";
              });
            },
            param: searchPattern,
          ),
          ClientCard(
            client: clientfound,
          )
        ],
      ),
    );
  }
}

class ClientCard extends StatelessWidget {
  final String? client;
  const ClientCard({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return Container();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration:  BoxDecoration(
                  color: lightColorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: const Text(
                  "Equipement affecté",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  boxShadow: [
                    BoxShadow(
                        color: CustomColors.gray400,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: 2.0),
                  ],
                ),
                child: Builder(builder: (context) {
                  if (client!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_off,
                          color: CustomColors.gray400,
                        ),
                        Text(
                          "Aucune affection",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  }
                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(client!),
                        const Text("Contrat : GP1234567"),
                      ],
                    ),
                  ]);
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
