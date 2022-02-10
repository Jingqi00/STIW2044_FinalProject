import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:project/login.dart';
import 'package:project/user.dart';
import 'config.dart';

class UpdatePassword extends StatefulWidget {
  final User user;
  const UpdatePassword({ Key? key, required this.user}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool _passwordVisible = true;
  late double screenHeight, screenWidth, resWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();

  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _password2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    _passwordEditingController.text = widget.user.password.toString();
    _password2EditingController.text = widget.user.password.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> LoginPage(user: widget.user)))),
          backgroundColor: Colors.yellow[600],
          centerTitle: true,
          title: const Text("UPDATE PASSWORD"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              _updatePasswordDialog();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 3,
      width: screenWidth,
        child: Container(
            decoration: const BoxDecoration(         
              image: DecorationImage(image: AssetImage('assets/images/img_editprofile.png'), alignment: Alignment.topCenter),
              shape: BoxShape.circle,
              color: Colors.green,
        )),
    );
  }

   Widget lowerHalf(BuildContext context){
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 4),
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
                        TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (val) => validatePassword(val.toString()),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
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
                        focusNode: focus,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
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

                  ]
                ),
                ),
              )
            ), 

            const SizedBox(
              height: 10,
            ),
            
          ],
        ),
      )
    );
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

  void _updatePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Save Change?",
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
                _updatePassword();
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

  void _updatePassword() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _pass = _passwordEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Updating in progress.."),
        title: const Text("Updating..."));
    progressDialog.show();

    http.post(Uri.parse(Config.server + "/sbusiness/php/update_password.php"),
        body: {
          "password": _pass,
          "email": widget.user.email,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Password Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
            backgroundColor: Colors.orange);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Update Failed. Try Again",
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