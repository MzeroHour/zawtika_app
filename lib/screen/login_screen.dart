import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/custom/btn.dart';
import 'package:zawtika/custom/toast_message.dart';
import 'package:zawtika/screen/auth_ui.dart';
import 'package:zawtika/screen/home_screen.dart';

import '../app_config/my_theme.dart';
import '../data_model/api_response.dart';
import '../data_model/user_model.dart';
import '../repository/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void onPressLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isEmpty) {
      toastMessage("Enter Email", Colors.white, Colors.red);
    } else if (password.isEmpty) {
      toastMessage("Enter Password", Colors.white, Colors.red);
    }
    if (email.isNotEmpty && password.isNotEmpty) {
      ApiResponse response =
          await AuthRepository().getLoginResponse(email, password);
      print('Response is ${response}');
      if (response.error == null) {
        _saveAndRedirectToHome(response.data as User);
      } else {
        toastMessage('${response.error}', Colors.white, Colors.grey[600]!);
      }
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('user_id', user.userId ?? 0);
    print('-----------${user.token}');
    print('-----------${user.id}');

    // ignore: use_build_context_synchronously
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => Home(user: user)),
    //     (route) => false);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen.buildScreen(
      context,
      AppConfig.app_name,
      AppConfig.hologram,
      buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * (3 / 3.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: MyTheme.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextField(
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
                          labelStyle: const TextStyle(fontSize: 14),
                          hintStyle: const TextStyle(fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: MyTheme.accent_color,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: MyTheme.light_grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextField(
                        controller: _passwordController,
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle password visibility
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: MyTheme.blue_grey,
                            ),
                          ),
                          labelStyle: const TextStyle(fontSize: 14),
                          hintStyle: const TextStyle(fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: MyTheme.accent_color,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: MyTheme.light_grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          print("Forgot Passwrod");
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return PasswordForget();
                          // }));
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyTheme.textfield_grey, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.accent_color,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressLogin();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: Center(
                    child: Text(
                  "or, create new account ?",
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                )),
              ),
              Container(
                height: 45,
                child: Btn.minWidthFixHeight(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  color: MyTheme.amber,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    print("Registration");
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return Registration();
                    // }));
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
