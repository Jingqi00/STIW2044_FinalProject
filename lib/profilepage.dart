import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project/creditpage.dart';
import 'package:project/login.dart';
import 'package:project/paymenthistory.dart';
import 'package:project/update_name.dart';
import 'package:project/update_password.dart';
import 'package:project/update_phoneno.dart';
import 'package:project/user.dart';
import 'config.dart';


class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({ Key? key, required this.user }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenHeight, screenWidth, resWidth;
  String titlecenter = "Loading data...";
  List orderlist = [];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple[300],
          centerTitle: true,
          title: const Text("PROFILE"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              _logoutDialog();
              },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height:15),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: Card(
                elevation: 15,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: screenHeight * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.user.username.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                        child: Divider(
                          color: Colors.blueGrey,
                          height: 2,
                          thickness: 2.0,
                        ),
                      ),
                      Table(
                        columnWidths: const {
                          0: FractionColumnWidth(0.3),
                          1: FractionColumnWidth(0.7)
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            const Icon(Icons.person),
                            Text(widget.user.name.toString()),
                          ]),
                          TableRow(children: [
                            const Icon(Icons.email),
                            Text(widget.user.email.toString()),
                          ]),
                          TableRow(children: [
                            const Icon(Icons.phone),
                            Text(widget.user.phoneno.toString()),
                          ]),
                          TableRow(children: [
                            const Icon(Icons.credit_score),
                            Text(widget.user.credit.toString()),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height:10),
            Expanded(
              child: GridView.count(
                primary:false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height:6),
                        const Icon(Icons.credit_score, size: 30.0),
                        MaterialButton(
                          onPressed: () => buyCreditPage(),
                          child: const Text("Buy Credit", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                        ),
                      ],),
                      color: Colors.purple[50],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height:6),
                        const Icon(Icons.payments_outlined, size: 30.0),
                        MaterialButton(
                          onPressed: () => viewPaymentHistory(),
                          child: const Text("View Payment History", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                        ),
                      ],),
                      color: Colors.pink[50],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height:6),
                        const Icon(Icons.settings_applications, size: 30.0),
                        MaterialButton(
                          onPressed: () => _updateProfile(),
                          child: const Text("Update Profile", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                        ),
                      ],),
                      color: Colors.yellow[50],
                  )
                ]
              )),
            const SizedBox(height:50),
          ]),
      )));
  }
  
 Future<void> buyCreditPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CreditPage(
                  user: widget.user,
                )));
                _loadNewCredit();
  }

  _loadNewCredit() {
    http.post(Uri.parse(Config.server + "/sbusiness/php/load_user.php"),
        body: {"email": widget.user.email}).then((response) {
      if (response.statusCode == 200 && response.body != "failed") {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        User user = User.fromJson(jsonResponse);
        setState(() {
          widget.user.credit = user.credit;
        });
      }
    });
  }

   Future<void> viewPaymentHistory() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const PaymentHistoryScreen(
                )));
                _loadPaymentHistory();
  }

  void _loadPaymentHistory() {
    http.post(Uri.parse(Config.server + "/sbusiness/php/load_paymenthistory.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          orderlist = extractdata["payment"];
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(user: widget.user)));
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

  Future<void> _updateProfile() async {
      showDialog(
        context: context,
           builder: (BuildContext context) {
              return AlertDialog(
                title: Container(child: const Padding(
                  padding: EdgeInsets.all(8.0),
                    child: Text('Profile Settings',style: TextStyle(color: Colors.white),),
                ),color: Colors.blueAccent,),
                    content: setupAlertDialoadContainer(context),
              );
            }
        );                    
  }

  Widget setupAlertDialoadContainer(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.grey[100],
          height: 300.0, 
          width: 300.0, 
          child: ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    trailing: const Icon(Icons.perm_identity_rounded),
                    title: const Text('Update Name'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UpdateProfile(user: widget.user
                                )));
                    },
                  ),
                  ListTile(
                    trailing: const Icon(Icons.phone_iphone_rounded),
                    title: const Text('Update Phone Number'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UpdatePhoneNumber(user: widget.user
                        )));
                    },
                  ),
                  ListTile(
                    trailing: const Icon(Icons.password_rounded),
                    title: const Text('Update Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UpdatePassword(user: widget.user
                        )));
                    },
                  ),
                ]
            ).toList(),
          )
        ),
        Align(
          alignment: Alignment.bottomRight,
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: (){
            Navigator.pop(context);
          },child: const Text("Cancel"),),
        )
      ],
    );
  }
}