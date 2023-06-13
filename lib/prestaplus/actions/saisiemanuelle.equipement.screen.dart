// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';

class SaisieManuelle extends StatefulWidget {
  final Function(String param) onSubmit;
  final MigAction migaction;
  const SaisieManuelle({
    Key? key,
    required this.onSubmit,
    required this.migaction,
  }) : super(key: key);

  @override
  State<SaisieManuelle> createState() => _SaisieManuelleState();
}

class _SaisieManuelleState extends State<SaisieManuelle> {
    var controller = TextEditingController();
    var focus = FocusNode();
    bool submited = false;
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                          "Saisissez le numdec",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: controller,
            focusNode: focus,
            autofocus: false,
            onFieldSubmitted: (value) {
              widget.onSubmit(value);
              setState(() {
                submited=true;
              });
            },
            decoration: const InputDecoration(
                label: Text("Saisissez le numdec"), prefixIcon: Icon(Icons.qr_code_2_sharp)),
          ),
        ),
        AnimatedOpacity(
          duration:  const Duration(milliseconds: 500),
          opacity:submited ? 1 : 0,
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("${widget.migaction.tache} de ${controller.text}"),
              ),),
          ),
        )
      ],
    );
  }
}
