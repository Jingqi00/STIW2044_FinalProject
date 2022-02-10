import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:project/mainpage.dart';
import 'package:project/user.dart';
import 'config.dart';

class UpdatePhoneNumber extends StatefulWidget {
  final User user;
  const UpdatePhoneNumber({ Key? key, required this.user }) : super(key: key);

  @override
  _UpdatePhoneNumberState createState() => _UpdatePhoneNumberState();
}

class _UpdatePhoneNumberState extends State<UpdatePhoneNumber> {
  late double screenHeight, screenWidth, resWidth;
  final focus = FocusNode();

  final TextEditingController _phonenoEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phonenoEditingController.text = widget.user.phoneno.toString();
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
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> MainPage(user: widget.user)))),
          backgroundColor: Colors.yellow[600],
          centerTitle: true,
          title: const Text("UPDATE PHONE NUMBER"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              _updatePhoneNumberDialog();
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
                      const Text(
                        "Enter new phone number",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600, 
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator:(val) => val!.isEmpty || (val.length < 10)
                            ? "Enter Valid Phone Number"
                            : null,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
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

  void _updatePhoneNumberDialog() {
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
                _updatePhoneNo();
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

  void _updatePhoneNo() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _phoneno = _phonenoEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Updating in progress.."),
        title: const Text("Updating..."));
    progressDialog.show();

    http.post(Uri.parse(Config.server + "/sbusiness/php/update_phoneno.php"),
        body: {
          "phoneno": _phoneno,
          "email": widget.user.email,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Phone Number Updated Successfully",
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