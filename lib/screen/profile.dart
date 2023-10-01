import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawtika/app_config/my_theme.dart';
import 'package:zawtika/data_model/user_model.dart';
import 'package:zawtika/screen/login_screen.dart';

import '../data_model/api_response.dart';
import '../repository/auth_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  int userId = 0;
  String userName = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      _nameController.text = _user?.name ?? '';
      _emailController.text = _user?.email ?? '';
      _phoneController.text = _user?.phone ?? '';
      _passwordController.text = _user?.phone ?? '';
      print('Name  ${_user?.name}');
      print('Userid  ${_user?.id}');
      print('User Phone  ${_user?.phone}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Profile',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/user.png',
                        scale: 5,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _user?.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Phone : ${_user?.phone ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    'assets/images/pattern.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'User Name',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'User Name',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.password,
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: MyTheme.splash_screen_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Update User Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
