// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:librairies/keycloack_auth.dart';
import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/class/exchange.equipement.controller.dart';
import 'package:portail_canalplustelecom_mobile/class/log.dart';
import 'package:portail_canalplustelecom_mobile/menu.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/floatingactionbuttonvisible.widget.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/tab.widget.dart';

class SimpleScaffold extends StatefulWidget {
  final Widget? body;
  final AppBar appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final GlobalKey<FABAnimatedState>? floatingActionButtonKey;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const SimpleScaffold({
    super.key,
    this.body,
    required this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonKey,
    this.floatingActionButtonLocation,
  });

  @override
  State<SimpleScaffold> createState() => _SimpleScaffoldState();
}

class _SimpleScaffoldState extends State<SimpleScaffold> {
  late GlobalKey<FABAnimatedState> floatingActionButtonKey =
      widget.floatingActionButtonKey ?? GlobalKey();

  toggleFloatingActionButton() =>
      floatingActionButtonKey.currentState?.toggle();
  showFloatingActionButton() => floatingActionButtonKey.currentState?.show();
  hideFloatingActionButton() => floatingActionButtonKey.currentState?.hide();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).languageCode;
    if (widget.body == null) return Container();
    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      floatingActionButton: FABAnimated(
          key: floatingActionButtonKey,
          floatingActionButton: widget.floatingActionButton),
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: Stack(
        children: [
          const _Background(),
          widget.body!,
        ],
      ),
    );
  }
}

class ScaffoldTabs extends StatefulWidget {
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final GlobalKey<FABAnimatedState>? floatingActionButtonKey;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final TabController? tabcontroller;
  final Map<HorizontalTab, Widget>? tabs;
  const ScaffoldTabs({
    super.key,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonKey,
    this.floatingActionButtonLocation,
    this.tabcontroller,
    this.tabs,
  });

  static ScaffoldTabsCore? of(BuildContext context) =>
      ScaffoldTabsCore.of(context);

  @override
  State<ScaffoldTabs> createState() => _ScaffoldTabsState();
}

class _ScaffoldTabsState extends State<ScaffoldTabs>
    with TickerProviderStateMixin {
  late TabController tabcontroller =
      TabController(length: widget.tabs?.length ?? 0, vsync: this);

  @override
  Widget build(BuildContext context) {
    return ScaffoldTabsCore(
      tabcontroller: tabcontroller,
      child: _ScaffoldTabsWidget(
        key: widget.key,
        appBar: widget.appBar,
        drawer: widget.drawer,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonKey: widget.floatingActionButtonKey,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        tabcontroller: tabcontroller,
        tabs: widget.tabs,
      ),
    );
  }
}

class ScaffoldTabsCore extends InheritedWidget {
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final GlobalKey<FABAnimatedState>? floatingActionButtonKey;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final TabController tabcontroller;
  final ExchangeEquipementController exchangeEquipementController =
      ExchangeEquipementController();
  final Map<HorizontalTab, Widget>? tabs;
  ScaffoldTabsCore({
    super.key,
    required super.child,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonKey,
    this.floatingActionButtonLocation,
    required this.tabcontroller,
    this.tabs,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  void movetomanual(DeviceBarCodes? scannedBarcode) {
    tabcontroller.animateTo(2);

    exchangeEquipementController.lastScan = DeviceBarCodes(
        numdec: scannedBarcode?.numdec,
        adresseMAC: scannedBarcode?.adresseMAC,
        numeroSerie: scannedBarcode?.numeroSerie,
        ontSerial: scannedBarcode?.ontSerial);
  }

  static ScaffoldTabsCore? of(BuildContext context) {
    var core = context.getInheritedWidgetOfExactType<ScaffoldTabsCore>();
    assert(core != null, "ScaffoldTabsCore not found in widgetTree");
    return core;
  }
}

class _ScaffoldTabsWidget extends StatefulWidget {
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final GlobalKey<FABAnimatedState>? floatingActionButtonKey;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final TabController tabcontroller;
  final Map<HorizontalTab, Widget>? tabs;
  const _ScaffoldTabsWidget({
    super.key,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonKey,
    this.floatingActionButtonLocation,
    required this.tabcontroller,
    this.tabs,
  });

  @override
  State<_ScaffoldTabsWidget> createState() => _ScaffoldTabsWidgetState();
}

class _ScaffoldTabsWidgetState extends State<_ScaffoldTabsWidget> {
  late GlobalKey<FABAnimatedState> floatingActionButtonKey =
      widget.floatingActionButtonKey ?? GlobalKey();

  toggleFloatingActionButton() =>
      floatingActionButtonKey.currentState?.toggle();
  showFloatingActionButton() => floatingActionButtonKey.currentState?.show();
  hideFloatingActionButton() => floatingActionButtonKey.currentState?.hide();

  @override
  void initState() {
    super.initState();
    widget.tabcontroller.addListener(() {
      hideFloatingActionButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: widget.appBar?.title,
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
                  controller: widget.tabcontroller,
                  tabs: widget.tabs!.keys.toList(),
                ),
              ),
            );
          }),
        ),
      ),
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonKey: floatingActionButtonKey,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: TabBarView(
        controller: widget.tabcontroller,
        children: widget.tabs!.values.toList(),
      ),
    );
  }
}

class ScaffoldMenu extends StatefulWidget {
  final Widget? child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final GlobalKey<FABAnimatedState>? floatingActionButtonKey;
  final Menu selectedmenu;
  final String title;
  const ScaffoldMenu({
    super.key,
    this.child,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonKey,
    this.selectedmenu = Menu.prestaplus,
    this.title = 'Portail C+T',
  });

  @override
  State<ScaffoldMenu> createState() => ScaffoldMenuState();
}

class ScaffoldMenuState extends State<ScaffoldMenu> {
  late Menu selectedMenu = widget.selectedmenu;
  late GlobalKey<FABAnimatedState> floatingActionButtonKey =
      widget.floatingActionButtonKey ?? GlobalKey();
  toggleFloatingActionButton() =>
      floatingActionButtonKey.currentState?.toggle();
  showFloatingActionButton() => floatingActionButtonKey.currentState?.show();
  hideFloatingActionButton() => floatingActionButtonKey.currentState?.hide();

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return ScaffoldTabs(
        drawer: const _CplusDrawer(),
        floatingActionButtonKey: floatingActionButtonKey,
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        tabs: selectedMenu.tabsAsMap,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
      );
    }
    return SimpleScaffold(
      floatingActionButtonKey: floatingActionButtonKey,
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: widget.child!,
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();
  @override
  Widget build(BuildContext context) {
    return Opacity(
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
  }
}

class _CplusDrawer extends StatelessWidget {
  const _CplusDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
              child: Image.asset(
            "assets/images/logo.png",
            width: 150,
          )),
        ),
        Expanded(
          child: ListView(children: [
            const Divider(),
            ...Menu.values.map((e) => e.tile(context)),
          ]),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Deconnection"),
          onTap: () async {
            var logoutUrl = ApplicationConfiguration
                .instance?.keycloakConfig.authorizationEndpoint;
            debugPrint(logoutUrl.toString());
            OAuthManager.of(context)?.logout(context).then((value) {
              if (value ?? false) OAuthManager.of(context)?.onHttpInit(null);
            });
          },
        ),
        Opacity(opacity: 0.5, child: Text("V${Log.packageInfo?.version}"))
      ],
    ));
  }
}
