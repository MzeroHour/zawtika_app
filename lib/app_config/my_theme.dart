import 'package:flutter/material.dart';

class MyTheme {
  /*configurable colors stars*/
  static Color accent_color = const Color.fromRGBO(122, 122, 122, 1);
  static Color red = const Color.fromARGB(255, 154, 11, 11);
  static Color accent_color_shadow =
      const Color.fromRGBO(129, 0, 0, 0.4); // this color is a dropshadow of
  static Color soft_accent_color = Color.fromRGBO(255, 166, 0, 1);
  static Color splash_screen_color = Color.fromRGBO(
      122, 122, 122, 1); // if not sure , use the same color as accent color
  /*configurable colors ends*/
  /*If you are not a developer, do not change the bottom colors*/
  static Color black = Color.fromARGB(255, 0, 0, 0);
  static Color white = const Color.fromRGBO(255, 255, 255, 1);
  static Color noColor = const Color.fromRGBO(255, 255, 255, 0);
  static Color light_grey = const Color.fromRGBO(239, 239, 239, 1);
  static Color dark_grey = const Color.fromRGBO(107, 115, 119, 1);
  static Color medium_grey = const Color.fromRGBO(167, 175, 179, 1);
  static Color blue_grey = const Color.fromRGBO(168, 175, 179, 1);
  static Color medium_grey_50 = const Color.fromRGBO(167, 175, 179, .5);
  static Color grey_153 = const Color.fromRGBO(153, 153, 153, 1);
  static Color dark_font_grey = const Color.fromRGBO(62, 68, 71, 1);
  static Color font_grey = Color.fromRGBO(107, 115, 119, 1);
  static Color textfield_grey = Color.fromRGBO(209, 209, 209, 1);
  static Color golden = Color.fromRGBO(255, 168, 0, 1);
  static Color amber = Color.fromRGBO(254, 234, 209, 1);
  static Color amber_medium = Color.fromRGBO(254, 240, 215, 1);
  static Color golden_shadow = Color.fromRGBO(255, 168, 0, .4);
  static Color green = Colors.green;
  static Color? green_light = Colors.green[200];
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;

  static String loremText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  static String thanks =
      "လူကြီးမင်း၏ မှာယူမှုအတွက် ကျွန်တော်တို့ဇောတိက ရွှေဆိုင်မှ အထူးပင်ကျေးဇူးတင်ရှိပါသည်။ မကြာမှီ အချိန်အနည်းငယ်အတွင်းမှာ လူကြီးမင်း၏ မှတ်ပုံတင်ထားသော ဖုန်းနံပါတ်သို့ ပြန်လည်ဆက်သွယ်ပေးသွားပါမည်။";
  //testing shimmer
  /*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/
}
