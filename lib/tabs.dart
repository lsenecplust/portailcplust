import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/prestaplus.screen.dart';

enum AllTabs {
  nextrdv(Icons.hail_rounded, "Presta+", PrestaplusScreen()),
  ;

  const AllTabs(this.icondata, this.label, this.view,);
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