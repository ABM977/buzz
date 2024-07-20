import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'Homepage.dart';
import 'chatscreen.dart';
import 'detailspage.dart';

class Otppage extends StatefulWidget {
  String phone_numberr;
  Otppage({Key? key, required this.phone_numberr});

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> {
  String code = "";
  String smscodee = "";
  String? verificationCode;
  final TextEditingController pinn = TextEditingController();

  VerifyPhonenumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${widget.phone_numberr}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          final User? user = FirebaseAuth.instance.currentUser;
          final uid = user!.uid;
          print(">>>>>>>>>>>>>${uid}");
          var currrentuser = await FirebaseFirestore.instance
              .collection("New_phone_otp_details")
              .doc(uid)
              .get();
          if (currrentuser.exists) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Homepage(email:"",number: "",name: "",bio: "",);
              },
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return DetailsPage(number:widget.phone_numberr, name: "", email:"",);
              },
            ));
          }
        });
      },
      verificationFailed: (FirebaseAuthException s) {
        print(s);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("${s.message}"),
            );
          },
        );
      },
      codeSent: (String? verificatioID, int? resendToken) {
        setState(() {
          print(">>>>>>>>>>>>>>>>>>>>>>>>>${verificatioID}");
          verificationCode = verificatioID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> submitOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationCode!, smsCode: pinn.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final curentuser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("New_phone_otp_details")
          .doc(curentuser!.uid)
          .get();
      if (snapshot.exists) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ChatScreen(receiverId: "",chatroomid:"" ,data:"" ,);
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailsPage(number:widget.phone_numberr,email:"", name:"",);
        }));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    VerifyPhonenumber();
  }

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
              Container(
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 280, top: 50),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFFf4b017),
                      )),
                ),
              ),
              Container(
                width: screenWidth,
                height: 250,
                child: Image(
                  image: AssetImage("assets/images/c.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Text("Verification",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: PinCodeTextField(
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(7),
                      selectedColor: Color(0xFFf4b017),
                      activeColor: Color(0xFFf4b017),
                      errorBorderColor: Colors.red,
                      inactiveColor: Color(0xFFf4b017),
                      fieldHeight: 50),
                  keyboardType: TextInputType.number,
                  boxShadows: [BoxShadow(color: Colors.black)],
                  enablePinAutofill: true,
                  textStyle: TextStyle(fontSize: 20, color: Color(0xFFf4b017)),
                  // backgroundColor: Color(0xFFf4b017),
                  autoDismissKeyboard: true,
                  cursorColor: Color(0xFFf4b017),
                  appContext: context,
                  length: 6,
                  // hintStyle: TextStyle(color: Colors.purple),
                  // hintCharacter: verificationCode,
                  controller: pinn,
                  onCompleted: (v) {
                    setState(() {
                      smscodee = pinn.text;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    submitOtp(
                    );
                  },
                  child: Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        "Verify",
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
              ),
              Padding(
                padding: const EdgeInsets.only(left:70,top: 40),
                child: Row(
                  children: [
                    Text("Didn't receive the OTP?  ",style:TextStyle(color: Colors.blueGrey,fontSize: 12)),

                    InkWell(onTap:(){},child: RichText(text:TextSpan (text:"Resend OTP",style: TextStyle(color: Color(0xFFf4b017),fontWeight:FontWeight.bold,fontSize: 15))))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
