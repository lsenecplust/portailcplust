import 'package:flutter/material.dart';


class CustomColors {


     static const Color blue= Color(0xFF0d6efd);
     static const Color indigo= Color(0xFF6610f2);
     static const Color purple= Color(0xFF6f42c1);
     static const Color pink= Color(0xFFd63384);
     static const Color red= Color(0xFFdc3545);
     static const Color orange= Color(0xFFfd7e14);
     static const Color yellow= Color(0xFFffc107);
     static const Color green= Color(0xFF198754);
     static const Color teal= Color(0xFF20c997);
     static const Color cyan= Color(0xFF0dcaf0);
     static const Color gray= Color(0xFF6c757d);
     static const Color graydark= Color(0xFF343a40);
     static const Color gray100= Color(0xFFf8f9fa);
     static const Color gray200= Color(0xFFe9ecef);
     static const Color gray300= Color(0xFFdee2e6);
     static const Color gray400= Color(0xFFced4da);
     static const Color gray500= Color(0xFFadb5bd);
     static const Color gray600= Color(0xFF6c757d);
     static const Color gray700= Color(0xFF495057);
     static const Color gray800= Color(0xFF343a40);
     static const Color gray900= Color(0xFF212529);
     static const Color primary= Color(0xFF0d6efd);
     static const Color secondary= Color(0xFF6c757d);
     static const Color success= Color(0xFF198754);
     static const Color info= Color(0xFF0dcaf0);
     static const Color warning= Color(0xFFffc107);
     static const Color danger= Color(0xFFdc3545);
     static const Color light= Color(0xFFf8f9fa);
     static const Color dark= Color(0xFF212529);

}

extension MyColorToMaterial on Color {
  MaterialColor get toMaterial => MaterialColor(value, colorCodes);

  Map<int, Color> get colorCodes => {
        50: Color.fromRGBO(red, blue, green, .1),
        100: Color.fromRGBO(red, blue, green, .2),
        200: Color.fromRGBO(red, blue, green, .3),
        300: Color.fromRGBO(red, blue, green, .4),
        400: Color.fromRGBO(red, blue, green, .5),
        500: Color.fromRGBO(red, blue, green, .6),
        600: Color.fromRGBO(red, blue, green, .7),
        700: Color.fromRGBO(red, blue, green, .8),
        800: Color.fromRGBO(red, blue, green, .9),
        900: Color.fromRGBO(red, blue, green, 1),
      };
}