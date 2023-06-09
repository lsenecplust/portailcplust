import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';

import 'auth.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'Portail C+T',
      debugShowCheckedModeBanner: false,
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
          useMaterial3: true,
          primarySwatch: CustomColors.pink.toMaterial,
          primaryColor: CustomColors.pink,
          appBarTheme: const AppBarTheme(backgroundColor: CustomColors.pink,foregroundColor: Colors.white),),
      home: SplashScreen.navigate(
        fit: BoxFit.contain,
        name: 'assets/rives/logo.riv',
        next: (context) => const AuthHandler(
          errorWidget: SomethingWenWrong(msg: "Erreur Auth"),
          child: RootContainer(),
        ),
        isLoading: true,
        backgroundColor: Colors.white,
        startAnimation: "Splash",
      ),
    );
  }
}
