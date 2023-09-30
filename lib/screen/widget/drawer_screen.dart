import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawtika/app_config/my_theme.dart';
import 'package:zawtika/screen/home_screen.dart';
import 'package:zawtika/screen/order_list_screen.dart';

import '../../data_model/api_response.dart';
import '../../data_model/user_model.dart';
import '../../repository/auth_repository.dart';
import '../login_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? _user;
  int userId = 0;
  String userName = '';

  //Get user detail
  Future<void> getUser() async {
    int userId = await AuthRepository.getUserId();
    ApiResponse response = await AuthRepository().getUserDetails(userId);
    if (response.error == null) {
      setState(() {
        _user = response.data as User;
      });
    } else if (response.error == unauthorized) {
      AuthRepository().logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  Future<void> setUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('user_name', _user?.name ?? '');
      prefs.setInt('userId', _user?.id ?? 0);
      print('Name  ${_user?.name}');
      print('Name  ${_user?.id}');
    });
  }

  @override
  void initState() {
    getUser().then((_) {
      setUserInfo();
      print('Name  ${_user?.name}');
      print('Userid  ${_user?.id}');
      print('User Phone  ${_user?.phone}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyTheme.accent_color,
            ),
            child: Container(
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.solidUserCircle,
                    color: Colors.grey[400],
                    size: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _user?.name ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add your Drawer items here
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_sharp),
            title: const Text('Order List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderListScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userAlt,
              size: 18,
            ),
            title: const Text('User Information'),
            onTap: () {
              Navigator.pop(context); // Close the Drawer
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.powerOff,
              size: 20,
            ),
            title: const Text('Logout'),
            onTap: () async {
              // Navigator.pop(context);
              await AuthRepository().logout();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
