import 'package:flutter/material.dart';
import 'package:rive_loading/rive_loading.dart';

class PortailIndicator extends StatelessWidget {
  const PortailIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100,maxHeight: 100),
        child: RiveLoading(
            name: 'assets/rives/logo.riv',
            loopAnimation: 'loading',
            onSuccess: (_) {
              debugPrint('Finished');
            },
            onError: (err, stack) {
              debugPrint('onError');
            }),
      ),
    );
  }
}
