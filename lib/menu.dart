import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/main.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/calendrier/calendar.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/recherche/recherche.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/scan/scan.screen.dart';

enum Menu {
  prestaplus(Icons.hail_rounded, "Presta+"),
  geoeligibitlite(Icons.map, "Géo-Eligitilitée"),
  ;

  const Menu(
    this.icondata,
    this.label,
  );
  final IconData icondata;
  final String label;

  Widget tile(BuildContext context) => ListTile(
        leading: Icon(icondata),
        title: Text(label),
        onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RootContainer(
                selectedmenu: this,
              ),
            )),
      );
  List<Tabs> get tabs => Tabs.values.where((e) => e.menu == this).toList();
}

enum Tabs {
  list(Menu.prestaplus, Icons.search, "Recherche", PrestaplusRechercheScreen()),
  calendar(Menu.prestaplus, Icons.calendar_month, "Calendrier", CalanderdarScreen()),
  scan(Menu.prestaplus, Icons.qr_code_2, "Scan", PrestaplusScanScreen()),
  nextrdv4(Menu.geoeligibitlite, Icons.map, "Geo", PrestaplusRechercheScreen()),
  ;

  const Tabs(
    this.menu,
    this.icondata,
    this.label,
    this.view,
  );
  final IconData icondata;
  final String label;
  final Menu menu;
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
