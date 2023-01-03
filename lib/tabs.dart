import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/prestaplus.screen.dart';

import 'class/http.dart';

enum AllTabs {
  nextrdv(Icons.hail_rounded, "Presta+", PrestaplusScreen()),
  test(Icons.textsms_outlined, "test", MyWidget()),
  ;

  const AllTabs(
    this.icondata,
    this.label,
    this.view,
  );
  final IconData icondata;
  final String label;
  final Widget view;

  Tab get tab => Tab(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icondata),
          ),
          Text(label),
        ],
      ));
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Http.instance.client!.credentials.expiration.toString()),
        ElevatedButton(
            onPressed: () async {
              Http.instance.get(context,
                  'https://re7.oss.canalplustelecom.com/pfs/api/Contrats/rechercher?query=lary sene&isAdress=false');
            },
            child: const Text("click me"))
      ],
    );
  }
}
