import 'package:flutter/material.dart';

class HorizontalTab extends StatelessWidget {
  final IconData icondata;
  final String label;
  const HorizontalTab({
    Key? key,
    required this.icondata,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icondata),
            ),
            Text(label),
          ],
        ),
    );
  }
}
