import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class PrestaplusScreen extends StatelessWidget {
  const PrestaplusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: Prestation.get(context),
      builder: (context, snapshot) {
        return PresationList(
          prestations: snapshot.data!
            ..sort(((a, b) => b.dateRdv.compareTo(a.dateRdv))),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          //decoration: ,
          onChanged: (value) {},
        ),
        ElevatedButton(
          child: const Text("Recherche"),
          onPressed: () {
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: [
              ...List.from(widget.prestations.map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PrestationCard(
                      prestation: e,                   
                    ),
                  ))),
            ]),
          ),
        ),
      ],
    );
  }
}
