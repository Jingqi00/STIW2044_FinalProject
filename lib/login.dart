import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/mainpage.dart';
import 'package:project/register.dart';
import 'package:project/update_password.dart';
import 'package:project/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  final User user;
  const LoginPage({Key? key,  required this.user}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenHeight, screenWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green,
                Colors.orange,
                Colors.white,
              ],
          ))),upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 2,
      width: screenWidth,
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
        height: 500,
        margin: EdgeInsets.only(top: screenHeight / 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Card(
                elevation: 10,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            "Please login to continue",
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),                    
                          
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".com")
                                  ? "Enter Valid Email"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelStyle: TextStyle(),
                                  labelText: 'Email',
                                  icon: Icon(
                                    Icons.mail,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            validator: (val) => val!.isEmpty 
                              ? "Enter a password" 
                              : null,
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            controller: _passwordEditingController,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(),
                                labelText: 'Password',       
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )),
                            obscureText: _passwordVisible,
                          ),  
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    _onRememberMeChanged(value!);
                                  },
                                ),
                                const Flexible(
                                  child: Text('Remember me',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )
                                ),),                               
                              ],),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                      fixedSize: Size(screenWidth / 3, 10)),
                                  child: const Text('Login', 
                                        style: TextStyle(
                                        fontSize: 16,
                                      )),
                                  onPressed: _loginButton,
                                ),

                                  const SizedBox(
                                    height: 10,
                                  ),      

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                     UpdatePassword(user: widget.user)))
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ))
                    ),
            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? ",
                    style: TextStyle(fontSize: 16.0)),
                GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                 RegisterPage(user: widget.user)))
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(user:widget.user),
                      ));                        
                      }, 
                      label: const Text('Back'),
                      icon: const Icon(Icons.arrow_back),                     
              ),            
            ),           
          ],
        )));
  }

  void _loginButton() {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Failed to sign in! Please fill in the login credentials and try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          backgroundColor: Colors.red,
          );
      _isChecked = false;
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Please wait.."), 
        title: const Text("Login"));
    progressDialog.show();
    String _email = _emailEditingController.text;
    String _pass = _passwordEditingController.text;
    http.post(Uri.parse(Config.server + "/sbusiness/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        User user = User.fromJson(jsonResponse);
        Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
            backgroundColor: Colors.orange);
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>  MainPage(user: user)));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
            backgroundColor: Colors.red);
      }
      progressDialog.dismiss();
    });
  }

  void storeremovepref(bool value) async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
          backgroundColor: Colors.red);
      _isChecked = false;
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
          backgroundColor: Colors.orange);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passwordEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
          backgroundColor: Colors.red);
    }
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        _isChecked = newValue;
        if (_isChecked) {
          storeremovepref(true);
        } else {
          storeremovepref(false);
        }
      });

  Future<void> loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1 && password.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passwordEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}
