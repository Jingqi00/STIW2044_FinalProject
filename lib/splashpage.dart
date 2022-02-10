import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo_myshop.png'),
                    fit: BoxFit.cover))),
      ],
    );
  }
  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    late User user;
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse(Config.server + "/sbusiness/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          user = User.fromJson(jsonResponse);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => HomePage(user: user))));
        } else {
          user = User(
              username: "na",
              name: "na",
              phoneno: "na",
              email: "na",
              password: "na",
              credit: "na");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => HomePage(user: user))));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
          user = User(
              username: "na",
              name: "na",
              phoneno: "na",
              email: "na",
              password: "na",
              credit: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => HomePage(user: user))));
    }
  }
}