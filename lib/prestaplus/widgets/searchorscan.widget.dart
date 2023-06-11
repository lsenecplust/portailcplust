import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scanner.widget.dart';

class SearchOrScanSwitch extends StatefulWidget {
  final ValueChanged<String?> onchange;
  const SearchOrScanSwitch({
    Key? key,
    required this.onchange,
  }) : super(key: key);

  @override
  State<SearchOrScanSwitch> createState() => _SearchOrScanSwitchState();
}

class _SearchOrScanSwitchState extends State<SearchOrScanSwitch> {
  bool scan = true;
  var circularRadius = BorderRadius.circular(10);
  var searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scanWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 150,
          child: BarCodeScanner(
            onDetect: (value) => widget.onchange(value.barcodes.first.rawValue),
          ),
        );
      }),
    );

    var searchWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodySmall!,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recherche équipement par :"),
                    Text("- num dec"),
                    Text("- num serie"),
                    Text("- adress mac"),
                  ],
                ),
              ),
            ),
          ),
          TextFormField(
            controller: searchcontroller,
            onFieldSubmitted: (s) => widget.onchange(s),
            decoration: const InputDecoration(
                label: Text("Recherche"), suffixIcon: Icon(Icons.search)),
          ),
        ],
      ),
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: CustomColors.gray300,
            borderRadius: circularRadius,
          ),
          child: ToggleButtons(
            isSelected: [scan, !scan],
            onPressed: (index) {
              setState(() {
                scan = !scan;
              });
            },
            borderRadius: circularRadius,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Scanner équipement',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Rechercher équipement'),
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: scan ? scanWidget : searchWidget,
        )
      ],
    );
  }
}
