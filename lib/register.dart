import 'dart:convert';  
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:project/user.dart';
import 'config.dart';
import 'homepage.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  final User user;
  const RegisterPage({Key? key,  required this.user}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  bool _passwordVisible = true;
  String eula = "";
  late double screenHeight, screenWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phonenoEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _password2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                Colors.blue,
                Colors.red,
              ],
          ))),upperHalf(context), lowerHalf(context),],
      ),
    ); 
  }

  Widget upperHalf(BuildContext context){
    return SizedBox(
      height: screenWidth / 2,
      width: screenWidth,  
      child: Container(
        decoration: const BoxDecoration(         
          image: DecorationImage(image: AssetImage('assets/images/logo_shop.png'), alignment: Alignment.topCenter),
           shape: BoxShape.circle,
        ),
      ),          
    );
  }  

  Widget lowerHalf(BuildContext context){
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              color: Colors.white,
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Form(
                  key: _formKey,
                child: Column(
                  children: <Widget>[
                     const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600, 
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      const Text("Sign up for an account for free", style: TextStyle(fontSize:12, fontStyle: FontStyle.italic)),

                      const SizedBox(
                        height: 10,
                      ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => validateUsername(val.toString()),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                          controller: _usernameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'User Name',
                            suffixText: '*',
                            suffixStyle: TextStyle(
                              color: Colors.red,
                            ),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator:(val) => val!.isEmpty || (val.length < 3)
                            ? "Name must be longer than 3"
                            : null,
                          focusNode: focus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus1);
                          },
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            suffixText: '*',
                            suffixStyle: TextStyle(
                              color: Colors.red,
                            ),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator:(val) => val!.isEmpty || (val.length < 10)
                            ? "Enter Valid Phone Number"
                            : null,
                          focusNode: focus1,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus2);
                          },
                          controller: _phonenoEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            suffixText: '*',
                            suffixStyle: TextStyle(
                              color: Colors.red,
                            ),
                            icon: Icon(Icons.phone),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator:(val) => val!.isEmpty || !val.contains("@") || !val.contains(".com")
                            ? "Enter Valid Email"
                            : null,
                          focusNode: focus2,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus3);
                          },
                          controller: _emailEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            suffixText: '*',
                            suffixStyle: TextStyle(
                              color: Colors.red,
                            ),
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),

                        TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (val) => validatePassword(val.toString()),
                        focusNode: focus3,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus4);
                        },
                        controller: _passwordEditingController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(),
                            labelText: 'Password',
                            suffixText: '*',
                            suffixStyle: const TextStyle(
                              color: Colors.red,
                            ),                            
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
                      
                      TextFormField(
                        style: const TextStyle(),
                        textInputAction: TextInputAction.done,
                        validator: (val) {
                          validatePassword(val.toString());
                          if (val != _password2EditingController.text) {
                            return "Password Mismatch";
                          } else {
                            return null;
                          }
                        },
                        focusNode: focus4,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus5);
                        },
                        controller: _password2EditingController,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixText: '*',
                            suffixStyle: const TextStyle(
                              color: Colors.red,
                            ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: _showEULA,
                              child: const Text('I have read and agree to the terms',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                          ),
                        ],
                      ),

                        const SizedBox(
                          height: 10,
                        ),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(screenWidth / 3, 50)),
                            child: const Text('Register', style: TextStyle(fontSize: 16),),
                            onPressed: _registerDialog,
                          ),
                  ]
                ),
                ),
              )
            ), 

            const SizedBox(
              height: 10,
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already Have An Account? ",
                    style: TextStyle(
                      fontSize: 16.0,
                    )),
                GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginPage(user: widget.user)))
                  },
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            GestureDetector(
              onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePage(user:widget.user)))
              },
              child: const Text(
                "<< Back to Home",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

          ],
        ),
      )
    );
  }

  String? validateUsername(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[_]).{8,30}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Username is required';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Please provide valid username';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please Enter Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
          backgroundColor: Colors.orange);
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
          backgroundColor: Colors.orange);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(), 
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerAccount();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color:Colors.black,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _registerAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _username = _usernameEditingController.text;
    String _name = _nameEditingController.text;
    String _phoneno = _phonenoEditingController.text;
    String _email = _emailEditingController.text;
    String _pass = _passwordEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();

    http.post(Uri.parse(Config.server + "/sbusiness/php/register_user.php"),
        body: {
          "username": _username,
          "name": _name,
          "phoneno": _phoneno,
          "email": _email,
          "password": _pass
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
            backgroundColor: Colors.orange);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed. Check Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
            backgroundColor: Colors.orange);
        progressDialog.dismiss();
        return;
      }
    });
  } 
}