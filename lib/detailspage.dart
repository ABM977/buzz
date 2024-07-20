import 'dart:io';

import 'package:buzz/Homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.email, required this.name, required this.number});
  String name;
  String email;
  String number;



  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController? name1;
  TextEditingController? mail1;
  TextEditingController? number1;
  TextEditingController bio1 = TextEditingController();
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name1 = TextEditingController(text: widget.name);
    mail1 = TextEditingController(text: widget.email);
    number1 = TextEditingController(text: widget.number);
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
          child: Column(
            children: [
              Container(
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 280, top: 40),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);

                        ///needs to change
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFFf4b017),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      aadhar.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                _showBottomsheet(context);
                              },
                              splashColor: Colors.black,
                              highlightColor: Colors.black,
                              child: CircleAvatar(
                                radius: 90,
                                backgroundImage: NetworkImage(aadhar),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _showBottomsheet(context);
                              },
                              splashColor: Colors.black,
                              highlightColor: Colors.black,
                              child: CircleAvatar(
                                radius: 90,
                                backgroundImage:
                                    AssetImage('assets/images/a.jpeg'),
                                // CircleAvatar(
                                //   radius: 100,
                                // child: Icon(Icons.account_circle_rounded,size: 150,color: Colors.white54,),
                                // backgroundImage: (aadhar.isNotEmpty ? NetworkImage(aadhar)
                                //     : AssetImage("assets/images/a.jpeg",),) as ImageProvider<Object>?
                              ),
                            ),
                      Positioned(
                        left: 140,
                        top: 140,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: () {
                              // getImageCamera();
                              // pickAadharImage();
                              _showBottomsheet(context);
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFFf4b017),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
                child: TextFormField(
                  style: TextStyle(
                      color: Color(0xFFf4b017), fontWeight: FontWeight.bold),
                  controller: name1,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Name",
                    hintStyle: TextStyle(color: Color(0xFFf4b017)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    helperText: "Enter your name here",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
                child: TextFormField(
                  style: const TextStyle(
                      color: Color(0xFFf4b017), fontWeight: FontWeight.bold),
                  controller: number1,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Number",
                    hintStyle: TextStyle(color: Color(0xFFf4b017)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    helperText: "Enter your number here",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
                child: TextFormField(
                  style: TextStyle(
                      color: Color(0xFFf4b017), fontWeight: FontWeight.bold),
                  controller: mail1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Color(0xFFf4b017)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    helperText: "Enter your email id here",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                      color: Color(0xFFf4b017), fontWeight: FontWeight.bold),
                  controller: bio1,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Bio",
                    hintStyle: TextStyle(color: Color(0xFFf4b017)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    helperText: "Enter your bio here",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 180),
                child: TextButton(
                    onPressed: () {
                      if (name1!.text.isEmpty ||
                          number1!.text.isEmpty ||
                          mail1!.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.black,
                                  elevation: double.infinity,
                                  title: Text("Fill the fields",style: TextStyle(color: Color(0xFFf4b017)),),
                                  alignment: Alignment.center,
                                ));
                      }else{
                        FirebaseFirestore.instance.collection("Profile_details").doc().set({
                          "Name":name1!.text,
                          "Number":widget.number,
                          "Email":widget.email,
                          "Bio":bio1.text,
                          "image url":aadhar,
                        }).then((value){
                          print("+++++++++adding");
                          return Navigator.push(context, MaterialPageRoute(builder:(context){return Homepage(name:name1!.text,number: widget.number,email: widget.email,bio:bio1.text);}));
                        });
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFf4b017)),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Take a photo"),
                  onTap: getImageCamera,
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined),
                  title: Text("Choose from gallery"),
                  onTap: pickAadharImage,
                ),
              ],
            ),
          );
        });
  }

  // File? doc;
  // String docUrl = "";
  // File? imageFile;
  // String imageUrl = "";
  // Future getImageCamera() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickImage(source: ImageSource.camera).then((xFile) async {
  //     if (xFile != null) {
  //       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${xFile.path}");
  //       imageFile = File(xFile.path);
  //       var ref = FirebaseStorage.instance
  //           .ref()
  //           .child('images')
  //           .child("${imageFile}.jpg");
  //       // .child("${xFile.name}.jpg");
  //       var uploadTask = await ref.putFile(imageFile!);
  //       imageUrl = await uploadTask.ref.getDownloadURL();
  //       print(imageUrl);
  //       setState(() {
  //         aadhar = imageUrl;
  //       });
  //     }
  //   });
  // }
  //
  // String aadharFilePath = "";
  // File? imageAadhar;
  // String aadhar = "";
  // Future pickAadharImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     print("imageTemp ======================================================================? ${imageTemp}");
  //     aadharFilePath = basename(imageTemp.path);
  //     print("aadharFilePath ================================================================? ${aadharFilePath}");
  //     setState(() => this.imageAadhar = imageTemp);
  //     // Create a storage reference from our app
  //     final storageRef = FirebaseStorage.instance.ref();
  //     // Create a reference to "mountains.jpg"
  //     final mountainImagesRef =
  //     storageRef.child("AdminAadharImage/$aadharFilePath");
  //     await mountainImagesRef.putFile(imageTemp);
  //     String aadharurl = await mountainImagesRef.getDownloadURL();
  //     print(aadharurl);
  //     setState(() {
  //       aadhar = aadharurl;
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  String aadhar = '';
  ImagePicker _picker = ImagePicker();

  Future getImageCamera() async {
    await _picker.pickImage(source: ImageSource.camera).then((xFile) async {
      if (xFile != null) {
        print(
            ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${xFile.path}");
        final pickedFile = File(xFile.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child("${pickedFile.path}.jpg");
        // .child("${xFile.name}.jpg");
        var uploadTask = await ref.putFile(pickedFile!);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        print(imageUrl);
        setState(() {
          aadhar = imageUrl;
        });
      }
    });
  }

  Future pickAadharImage() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((xFile) async {
      if (xFile != null) {
        final pickedFile = File(xFile.path);
        final aadharFilePath = basename(pickedFile.path);
        print(
            "aadharFilePath ================================================================? ${aadharFilePath}");
        // Create a storage reference from our app
        final storageRef = FirebaseStorage.instance.ref();
        // Create a reference to "mountains.jpg"
        final mountainImagesRef =
            storageRef.child("AdminAadharImage/$aadharFilePath");
        await mountainImagesRef.putFile(pickedFile!);
        final imageUrl = await mountainImagesRef.getDownloadURL();
        setState(() {
          aadhar = imageUrl;
        });
      }
    });
  }
}
