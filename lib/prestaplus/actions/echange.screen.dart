import 'package:flutter/material.dart';

import 'package:portail_canalplustelecom_mobile/dao/action.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';

class Echange extends StatelessWidget {
    final Prestation prestation;
  final MigAction migaction;
  const Echange({
    Key? key,
    required this.prestation,
    required this.migaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
