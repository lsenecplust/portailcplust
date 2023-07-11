import 'package:flutter/material.dart';

class FABAnimated extends StatefulWidget {
  final Widget? floatingActionButton;
  final bool visible;
  const FABAnimated({
    Key? key,
    this.visible = false,
    this.floatingActionButton,
  }) : super(key: key);

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
        secondChild: Container(),
        firstChild: widget.floatingActionButton ?? Container());
  }
}
