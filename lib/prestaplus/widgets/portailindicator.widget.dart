import 'package:flutter/material.dart';
import 'package:rive_loading/rive_loading.dart';

class PortailIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  const PortailIndicator({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
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
      ),
    );
  }
}


class Processindicator extends StatelessWidget {
  final double? width;
  final double? height;
  const Processindicator({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RiveLoading(
          name: 'assets/rives/processindicator.riv',
          loopAnimation: 'Timeline 1',
          onSuccess: (_) {
            debugPrint('Finished');
          },
          onError: (err, stack) {
            debugPrint('onError');
          }),
    );
  }
}