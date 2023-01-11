import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';

class PrestaplusRechercheScreen extends StatefulWidget {
  const PrestaplusRechercheScreen({super.key});

  @override
  State<PrestaplusRechercheScreen> createState() =>
      _PrestaplusRechercheScreenState();
}

class _PrestaplusRechercheScreenState extends State<PrestaplusRechercheScreen> {
  var controller = TextEditingController();
  var future = Future.delayed(const Duration(seconds: 0))
      .then((value) => List<Prestation>.empty());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
                label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
          ),
        ),
        ElevatedButton(
          child: const Text("Recherche"),
          onPressed: () {
            setState(() {
              future = controller.text.isEmpty
                  ? Prestation.get(context)
                  : Prestation.search(context, controller.text);
            });
          },
        ),
        Expanded(
            child: PresationList(
          prestations: future,
        ))
      ],
    );
  }
}

class PresationList extends StatefulWidget {
  final Future<List<Prestation>> prestations;
  const PresationList({
    Key? key,
    required this.prestations,
  }) : super(key: key);

  @override
  State<PresationList> createState() => _PresationListState();
}

class _PresationListState extends State<PresationList> {
  var olderprestation = false;
  var prestations = List<Prestation>.empty();

  setfilter(List<Prestation> prestationsfound) {
    prestations = olderprestation
        ? prestationsfound
        : prestationsfound
            .where((e) => e.dateRdv.isAfter(DateTime.now()))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
        future: widget.prestations,
        builder: (context, snapshot) {
          var prestationsfound = snapshot.data!
            ..sort(((a, b) => b.dateRdv.compareTo(a.dateRdv)));
          if (prestationsfound.isEmpty) {
            return Container();
          }
          setfilter(prestationsfound);

          return Column(
            children: [
              Visibility(
                visible: prestationsfound
                    .any((element) => element.dateRdv.isBefore(DateTime.now())),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 268,
                    height: 50,
                    child: SwitchListTile(
                        title: const Text("Rendez-vous antérieur"),
                        value: olderprestation,
                        onChanged: ((value) {
                          setState(() {
                            olderprestation = value;
                          });
                        })),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [
                    ...List.from(prestations.map((e) => Padding(
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
        });
  }
}
