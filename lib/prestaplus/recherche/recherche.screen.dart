import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/loader.riv.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:librairies/futurebuilder.dart';
import 'package:portail_canalplustelecom_mobile/widgets/toggle.buttons.widget.dart';

class PrestaplusRechercheScreen extends StatefulWidget {
  const PrestaplusRechercheScreen({super.key});

  @override
  State<PrestaplusRechercheScreen> createState() =>
      _PrestaplusRechercheScreenState();
}

class _PrestaplusRechercheScreenState extends State<PrestaplusRechercheScreen> {
  var controller = TextEditingController();
  var focus = FocusNode();
  var future = Future.delayed(const Duration(seconds: 0))
      .then((value) => List<Prestation>.empty());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => gosearch());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: controller,
            focusNode: focus,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) => gosearch(),
            autofocus: false,
            decoration: const InputDecoration(
                label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
          ),
        ),
        ElevatedButton(onPressed: gosearch, child: const Text("Recherche")),
        Expanded(
            child: PresationList(
          prestations: future,
        ))
      ],
    );
  }

  void gosearch() {
    focus.unfocus();
    setState(() {
      future = controller.text.isEmpty
          ? Prestation.get(context)
          : Prestation.search(context, controller.text);
    });
  }
}

class PresationList extends StatefulWidget {
  final Future<List<Prestation>> prestations;
  const PresationList({
    super.key,
    required this.prestations,
  });

  @override
  State<PresationList> createState() => _PresationListState();
}

class _PresationListState extends State<PresationList> {
  var showOlderPrestation = false;
  LoaderController controller = LoaderController();
  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
        progressIndicator: const PortailIndicator(),
        future: widget.prestations,
        builder: (context, snapshot) {
          var prestations = snapshot.data!
            ..sort(((a, b) => b.dateRdv.compareTo(a.dateRdv)));

          if (prestations.isEmpty) {
            return Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 2, child: Container()),
                  const Icon(
                    Icons.no_backpack,
                    size: 50,
                  ),
                  const Text("Aucun résultat"),
                  Expanded(flex: 5, child: Container()),
                ],
              ),
            );
          }

          if (showOlderPrestation == false) {
            prestations = prestations
                .where((e) => e.dateRdv.isAfter(DateTime.now()))
                .toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToogleButtons(
                  buttons: [
                    ToogleButton(text: "Rendez-vous futures"),
                    ToogleButton(text: "Tous les Rendez-vous"),
                  ],
                  onSelectIndexChanged: (selectedindex) {
                    setState(() {
                      showOlderPrestation = selectedindex == 1;
                    });
                  },
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
