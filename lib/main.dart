import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/menu.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';

import 'auth.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'Portail C+T mobile',
      supportedLocales: const <Locale>[
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      theme: ThemeData(
          primarySwatch: CustomColors.pink.toMaterial,
          appBarTheme: const AppBarTheme(backgroundColor: CustomColors.dark),
          iconTheme: const IconThemeData(color: CustomColors.pink)),
      home: SplashScreen.navigate(
        fit: BoxFit.cover,
        name: 'assets/rives/intro.riv',
        next: (context) => const AuthHandler(
          errorWidget: SomethingWenWrong(msg: "Erreur Auth"),
          child: RootContainer(),
        ),
        isLoading: true,
        backgroundColor: Colors.white,
        startAnimation: "intro",
      ),
    );
  }
}

class RootContainer extends StatefulWidget {
  final Widget? child;
  final Menu selectedmenu;
  final String title;
  const RootContainer({
    Key? key,
    this.child,
    this.selectedmenu = Menu.prestaplus,
    this.title = 'Portail C+T',
  }) : super(key: key);

  @override
  State<RootContainer> createState() => _RootContainerState();
}

class _RootContainerState extends State<RootContainer>
    with TickerProviderStateMixin {
  late Menu selectedMenu;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    selectedMenu = widget.selectedmenu;
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
            child: ColoredBox(
              color: CustomColors.graydark,
              child: TabBar(
                isScrollable: false,
                indicatorColor: CustomColors.pink.withOpacity(0.99),
                controller: tabcontroller,
                tabs: List.from(selectedMenu.tabs.map((e) => e.tab)),
              ),
            ),
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
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
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
