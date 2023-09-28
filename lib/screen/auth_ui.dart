import 'package:flutter/material.dart';
import 'package:zawtika/app_config/my_theme.dart';

class AuthScreen {
  static Widget buildScreen(
      BuildContext context, String headerText, String hologram, Widget child) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: MyTheme.splash_screen_color,
            child: Stack(
              children: [
                Positioned(
                    top: 200,
                    child: Image.asset(
                      'assets/images/pattern.png',
                    )),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: Image.asset('assets/images/logo.png'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        headerText,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        hologram,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 30, top: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        ),
                      ),
                      child: child,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
