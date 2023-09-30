var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text =
      "@ Zawtika " + this_year; //this shows in the splash screen
  static String app_name =
      "Zawtika Gold Shop"; //this shows in the splash screen
  static String hologram = 'မြင်သူတိုင်းစိတ်တိုင်းဘဝင်ကျ ရွှေမှာဆိုဇောတိက';

  // Default Localhost Port ""http://10.0.2.2:8000/api";"

  // ignore: constant_identifier_names
  static const String BASE_URL = "http://172.30.31.20:8000/api";
  // static const String BASE_URL = "https://os.zawtikajewellery.com/api";

  @override
  String toString() {
    return super.toString();
  }
}
