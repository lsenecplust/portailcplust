import 'package:flutter/material.dart';

class HorizontalTab extends StatelessWidget {
  final IconData icondata;
  final String label;
  const HorizontalTab({
    super.key,
    required this.icondata,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(icondata),
      text: label,
    );
  }
}
