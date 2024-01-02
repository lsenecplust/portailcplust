import 'package:flutter/material.dart';

class ToogleButtons extends StatefulWidget {
  final List<ToogleButton> buttons;
  final int initialIndex;
  final double height;
  final void Function(int selectedindex) onSelectIndexChanged;
  const ToogleButtons({
    super.key,
    required this.buttons,
    this.initialIndex = 0,
    this.height = 50,
    required this.onSelectIndexChanged,
  });

  @override
  State<ToogleButtons> createState() => _ToogleButtonsState();
}

class _ToogleButtonsState extends State<ToogleButtons> {
  late int selectedindex = widget.initialIndex;
  late double boxX = widget.initialIndex - 1;

  double get getboxX => -1 + selectedindex * 2 / (widget.buttons.length - 1);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
                height: widget.height,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(widget.height),
                )),
            AnimatedContainer(
              duration: Durations.long1,
              alignment: Alignment(boxX, 0),
              child: Container(
                  width: constraints.maxWidth / widget.buttons.length,
                  height: widget.height,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(widget.height))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(widget.buttons.length, (index) {
                  return Expanded(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.height),
                      ),
                      onTap: () {
                        if (selectedindex == index) return;
                        setState(() {
                          selectedindex = index;
                          boxX = getboxX;
                        });

                        widget.onSelectIndexChanged(index);
                      },
                      child: DefaultTextStyle(
                        style: TextStyle(
                            color: selectedindex == index
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.primary),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: widget.buttons[index].widget,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ],
        );
      },
    );
  }
}

class ToogleButton {
  final String text;
  final Icon? icon;
  ToogleButton({
    required this.text,
    this.icon,
  });

  Widget get widget {
    if (icon == null) {
      return Text(
        text,
        textAlign: TextAlign.center,
      );
    }
    return Row(
      children: [icon!, Text(text, textAlign: TextAlign.center)],
    );
  }
}
