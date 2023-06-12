import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/menu.dart';

class RootContainer extends StatefulWidget {
  final Widget? child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Function(Widget?, FloatingActionButtonLocation?)?
      setFloatingActionButton;
  final Menu selectedmenu;
  final String title;
  const RootContainer({
    Key? key,
    this.child,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.setFloatingActionButton,
    this.selectedmenu = Menu.prestaplus,
    this.title = 'Portail C+T',
  }) : super(key: key);

  @override
  State<RootContainer> createState() => RootContainerState();
}

class RootContainerState extends State<RootContainer>
    with TickerProviderStateMixin {
  late Menu selectedMenu = widget.selectedmenu;
  late Widget? floatingActionButton = widget.floatingActionButton;
  late FloatingActionButtonLocation? floatingActionButtonLocation =
      widget.floatingActionButtonLocation;

  setFloatingActionButton(Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation) {
    setState(() {
      this.floatingActionButton = floatingActionButton;
      this.floatingActionButtonLocation = floatingActionButtonLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).languageCode;
    TabController tabcontroller =
        TabController(length: selectedMenu.tabs.length, vsync: this);
    Widget background = Opacity(
      opacity: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Image.asset('assets/images/group-10.png')),
                Expanded(child: Image.asset('assets/images/group-39.png')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Image.asset('assets/images/footer.png',
                        alignment: Alignment.bottomRight)),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.child == null) {
      return Scaffold(
        drawer: const CplusDrawer(),
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                color: Colors.white,
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Center(
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: lightColorScheme.primary.withOpacity(0.99),
                    controller: tabcontroller,
                    tabs: List.from(selectedMenu.tabs.map((e) => e.tab)),
                  ),
                ),
              );
            }),
          ),
        ),
        body: Stack(
          children: [
            background,
            TabBarView(
              controller: tabcontroller,
              children: List.from(selectedMenu.tabs.map((e) => e.view)),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Stack(
        children: [
          background,
          widget.child!,
        ],
      ),
    );
  }
}

class CplusDrawer extends StatelessWidget {
  const CplusDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Image.asset(
          "assets/images/logo.png",
          width: 150,
        )),
      ),
      const Divider(),
      ...Menu.values.map((e) => e.tile(context))
    ]));
  }
}
