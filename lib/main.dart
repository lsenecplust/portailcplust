import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/tabs.dart';

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
      theme: ThemeData(
        primarySwatch: CustomColors.pink.toMaterial,
        appBarTheme: const AppBarTheme(backgroundColor: CustomColors.dark),
      ),
      home: SplashScreen.navigate(
        fit: BoxFit.cover,
        name: 'assets/rives/intro.riv',
        next: (context) => const AuthHandler(
          errorWidget: SomethingWenWrong(msg: "Erreur Auth"),
          child: RootContainer(),
        ),
        until: () => Future.delayed(const Duration(seconds: 3)),
        backgroundColor: Colors.white,
        startAnimation: "intro",
      ),
    );
  }
}

class RootContainer extends StatefulWidget {
  final Widget? child;
  final String title;
  const RootContainer({
    Key? key,
    this.child,
    this.title = 'Portail C+T',
  }) : super(key: key);

  @override
  State<RootContainer> createState() => _RootContainerState();
}

class _RootContainerState extends State<RootContainer>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabcontroller =
        TabController(length: AllTabs.values.length, vsync: this);
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
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: ColoredBox(
              color: CustomColors.pink,
              child: TabBar(
                isScrollable: false,
                indicatorColor: CustomColors.pink.withOpacity(0.99),
                controller: tabcontroller,
                tabs: List.from(AllTabs.values.map((e) => e.tab)),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            background,
            TabBarView(
              controller: tabcontroller,
              children: List.from(AllTabs.values.map((e) => e.view)),
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
