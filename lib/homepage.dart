import 'package:flutter/material.dart';
import 'package:project/mainpage.dart';
import 'package:project/register.dart';
import 'package:project/user.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key,  required this.user}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double screenHeight, screenWidth;
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
                Colors.purple,
                Colors.yellow,
              ],
          ))),upperHalf(context), lowerHalf(context)],       
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 2,
      width: screenWidth,
      child: Container(
        margin: const EdgeInsets.all(80.0),
        decoration: const BoxDecoration(         
          image: DecorationImage(image: AssetImage('assets/images/logo_shop.png') ,fit: BoxFit.cover),
          shape: BoxShape.circle,
        ),
        child: 
        const Align(
          alignment: Alignment(1.8,1.8),
          child: Text("Login or sign up from here to access our application", textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        ), 
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 230), 
          MaterialButton(
          height: 50,
          minWidth: 300,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(user: widget.user)));
          },

          color: Colors.lightBlue[600],
          elevation: 0,

          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
          ),
          child: const Text("LOGIN", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white
          ),
        ),
        ),

        const SizedBox(height: 20), 

        MaterialButton(
          height: 50,
          minWidth: 300,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(user: widget.user)));
          },

          color: Colors.lightBlue[600],
          elevation: 0,

          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
          ),
          child: const Text("GUEST", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white
          ),
        ),
        ),   
          const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? ",
                    style: TextStyle(fontSize: 16)),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),    

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MainPage(user: widget.user)))
                  },
                  child: const Text(
                    "Back to Main Page",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}