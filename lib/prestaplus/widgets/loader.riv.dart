import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoaderIndicator extends StatefulWidget {
  final LoaderController? loadingController;
  const LoaderIndicator({super.key, this.loadingController});

  @override
  State<LoaderIndicator> createState() => _LoaderIndicatorState();
}

class _LoaderIndicatorState extends State<LoaderIndicator> {
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);

    if (widget.loadingController != null) {
      widget.loadingController!.checkTrigger =
          controller.findInput<bool>('Check') as SMITrigger;
      widget.loadingController!.errorTrigger =
          controller.findInput<bool>('Error') as SMITrigger;
      widget.loadingController!.resetTrigger =
          controller.findInput<bool>('Reset') as SMITrigger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RiveAnimation.asset(
        'assets/rives/loader.riv',
        fit: BoxFit.cover,
        onInit: _onRiveInit,
      ),
    );
  }
}

class LoaderController {
  SMITrigger? checkTrigger;
  SMITrigger? errorTrigger;
  SMITrigger? resetTrigger;

  void check() {
    checkTrigger?.fire();
  }

  void error() {
    errorTrigger?.fire();
  }

  void reset() {
    resetTrigger?.fire();
  }

  LoaderController();
}
