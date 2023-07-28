import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/auth.dart';
import 'package:portail_canalplustelecom_mobile/geoeligibilite/geoeligibilites.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/calendrier/calendar.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/recherche/recherche.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/scan/scan.screen.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/tab.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/scaffold.widget.dart';

enum Menu {
  prestaplus(Icons.hail_rounded, "Presta+"),
  geoeligibitlite(Icons.map, "Géo-Eligibilitée"),
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
      onTap: () => OAuthManager.of(context)
          ?.navigatePushReplacement(context, ScaffoldMenu(selectedmenu: this)));
  List<Tabs> get tabs => Tabs.values.where((e) => e.menu == this).toList();
  Map<HorizontalTab, Widget> get tabsAsMap => {for (Tabs t in tabs) t.tab: t.view};
}

enum Tabs {
  list(Menu.prestaplus, Icons.search, "Recherche", PrestaplusRechercheScreen()),
  calendar(
      Menu.prestaplus, Icons.calendar_month, "Calendrier", CalanderdarScreen()),
  scan(Menu.prestaplus, Icons.qr_code_2, "Scan", PrestaplusScanScreen()),
  nextrdv4(Menu.geoeligibitlite, Icons.map, "Geo", GeoEligibiliteScreen()),
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

  HorizontalTab get tab => HorizontalTab(
        icondata: icondata,
        label: label,
      );
}
