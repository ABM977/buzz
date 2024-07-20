import 'package:buzz/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Homepage.dart';
import 'detailspage.dart';
import 'otppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool password1 = true;
  final _auth = FirebaseAuth.instance;
  final _googleSignin = GoogleSignIn();
  String _error = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  void check() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? c = await pref.getBool("logstatus");
    if (c == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => LoginPage()));
    }
  }

  TextEditingController number1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: screenWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: screenWidth,
                      height: 300,
                      child: Image(
                        image: AssetImage("assets/images/c.png"),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 101,),
                child: Row(
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "LOGIN TO",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                          text: TextSpan(
                              text: "BuZz",
                              style: TextStyle(
                                  color: Color(0xFFf4b017),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Verify your phone number",
                style: TextStyle(color: Colors.blueGrey, fontSize: 13),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  height: 80,
                  child: TextField(
                    controller: number1,
                    maxLength: 10,
                    style: TextStyle(color: Color(0xFFf4b017)),
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xFFf4b017),
                    decoration: InputDecoration(
                      prefix: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CountryCodePicker(
                          showCountryOnly: true,
                          // dialogSize: Size(screenWidth, 400),
                          favorite: ["+91"],
                          dialogTextStyle:
                              TextStyle(color: Color(0xFFf4b017), fontSize: 25),
                          // barrierColor: Color(0xFFf4b017),
                          dialogBackgroundColor: Colors.black,
                          textStyle: TextStyle(
                            color: Color(0xFFf4b017),
                          ),
                        ),
                      ),
                      labelText: "Phone",
                      labelStyle: TextStyle(color: Color(0xFFf4b017)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFf4b017)),
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      suffixIcon: number1.text.length == 10
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, bottom: 5),
                              child: Icon(
                                Icons.check,
                                color: Colors.lightGreenAccent,
                                size: 25,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (number1.text.length == 10) {
                    print(">>>>>>>>>>>>>>>>>>>>>${number1.text}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Otppage(
                                  phone_numberr: number1.text,
                                )));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black26,
                            title: Text(
                              "Please enter a 10-digit number ",
                              style: TextStyle(
                                  color: Color(0xFFf4b017), fontSize: 20),
                            ),
                          );
                        });
                  }
                },
                child: Container(
                  width: 120,
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFf4b017)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)))),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 35,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(color: Color(0xFFf4b017)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 10,
                        endIndent: 30,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "You can continue with ",
                style: TextStyle(color: Color(0xFFf4b017)),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 90, left: 10),
                child: InkWell(
                    onTap: () async {
                      try {
                        final GoogleSignInAccount? googleuser =
                            await _googleSignin.signIn();
                        final GoogleSignInAuthentication googleAuth =
                            await googleuser!.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        final userCredential =
                            await _auth.signInWithCredential(credential);
                        print(">>>>>>>>${userCredential.user!.uid}");
                        if (userCredential.user != null) {
                          String email = googleuser.email;
                          String? name = googleuser.displayName;
                          final currentUser = FirebaseAuth.instance.currentUser;
                          print(">>>>>>>>>>..${email}");
                          print(">>>>>>>>>>..${name}");
                          final snapshot = await FirebaseFirestore.instance
                              .collection("google_signin_credentials")
                              .doc(currentUser!.uid)
                              .get();
                          if (snapshot.exists) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage(name:name!,email:email,number:number1.text,bio: "",)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(name: name!,email: email,number: "",)));
                          }
                        }
                      } on FirebaseAuthException catch (v) {
                        setState(() {
                          _error = v.message!;
                        });
                      } catch (v) {
                        setState(() {
                          _error = "Failed to sign in with google";
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundImage: AssetImage("assets/images/google.jpg"),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
