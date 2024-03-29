import 'package:flutter/material.dart';

class FABAnimated extends StatefulWidget {
  final Widget? floatingActionButton;
  final bool visible;
  const FABAnimated({
    super.key,
    this.visible = false,
    this.floatingActionButton,
  });

  @override
  State<FABAnimated> createState() => FABAnimatedState();
}

class FABAnimatedState extends State<FABAnimated> {
  late bool visible = widget.visible;

  void show() {
    try {
      setState(() {
        visible = true;
      });
    } catch (_) {}
  }

  void hide() {
    try {
      setState(() {
        visible = false;
      });
    } catch (_) {}
  }

  void toggle() {
    try {
      setState(() {
        visible = !visible;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.floatingActionButton == null) return Container();
    return AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        crossFadeState:
            visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        secondChild: const Visibility(
          visible: false,
          child: Placeholder(),
        ),
        firstChild: widget.floatingActionButton!);
  }
}
