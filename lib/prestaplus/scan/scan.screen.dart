import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/authenticatedhttp.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/equipement.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class PrestaplusScanScreen extends StatelessWidget {
  const PrestaplusScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scanner(
          ondetect: (String? code) {},
        ),
        ElevatedButton(
          child: const Text("test"),
          onPressed: () {
            print(AuthenticatedHttp.instance.client!.credentials.accessToken);
          },
        ),
        const Expanded(child: EquipementFuture(param: "ALCLB18C5317"))
      ],
    );
  }
}

class EquipementFuture extends StatelessWidget {
  final String param;
  const EquipementFuture({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: Equipement.get(context, param),
      builder: (context, snapshot) {
        var equipements = snapshot.data!;
        return ListView(
          children:
              List.from(equipements.map((e) => EquipementCard(equipement: e))),
        );
      },
    );
  }
}

class EquipementCard extends StatelessWidget {
  final Equipement equipement;
  const EquipementCard({super.key, required this.equipement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          padding: const EdgeInsets.all(8.0),
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
          child: Text(equipement.adresseMAC)),
    );
  }
}
