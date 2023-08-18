import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/portailindicator.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget? progressIndicator;
  final Widget? noelement;
  final Widget? error;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      builder;
       final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)?
      errorBuilder;

  const CustomFutureBuilder(
      {Key? key,
      required this.future,
      this.progressIndicator,
      this.noelement,
      this.error,
      required this.builder, this.errorBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: SomethingWenWrong(
                  line1: "network issue",
                ),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
              return progressIndicator ??
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PortailIndicator(),
                  ));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return errorBuilder?.call(context,snapshot) ?? error ??
                    Center(
                      child: SomethingWenWrong(
                        line1: snapshot.error.toString(),
                      ),
                    );
              }
              if (snapshot.hasData==false && (null is T) == false ) {
                return noelement ??
                    const Center(
                      child: SizedBox(
                        height: 70,
                        child: SomethingWenWrong(
                          line1: "No Data",
                        ),
                      ),
                    );
              }
              return builder(context, snapshot);
          }
        });
  }
}
