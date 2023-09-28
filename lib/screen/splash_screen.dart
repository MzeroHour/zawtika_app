import 'package:flutter/material.dart';
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/app_config/my_theme.dart';
import 'package:zawtika/repository/auth_repository.dart';
import 'package:zawtika/screen/login_screen.dart';

import '../custom/device_info.dart';
import '../custom/toast_message.dart';
import '../data_model/api_response.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _loadUserInfo() async {
    String token = await AuthRepository.getToken();
    int userId = await AuthRepository.getUserId();
    print('User Id $userId');

    print('Token is = $token');
    if (token == '') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } else {
      ApiResponse response = await AuthRepository().getUserDetails(userId);
      print('User Data ${response.data}');
      if (response.error == null) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/home');
      } else {
        toastMessage('${response.error}', Colors.white, Colors.grey[600]!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      _loadUserInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen();
  }

  Widget splashScreen() {
    return Scaffold(
      body: Container(
        width: DeviceInfo(context).width,
        height: DeviceInfo(context).height,
        color: MyTheme.splash_screen_color,
        child: Stack(children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0, top: 30),
                  child: Hero(
                    tag: 'Screen Image',
                    child: Container(
                      height: 300,
                      width: 300,
                      child: Image.asset(
                        "assets/images/logo.png",
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    AppConfig.app_name,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    AppConfig.hologram,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 51.0),
                child: Text(
                  AppConfig.copyright_text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Image(image: AssetImage('assets/images/pattern.png')),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
