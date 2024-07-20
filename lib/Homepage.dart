import 'dart:io';
import 'package:buzz/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({
    Key? key,
    required this.name,
    required this.number,
    required this.email,
    required this.bio,
  });
  String name;
  String email;
  String number;
  String bio;
  String? url;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<DocumentSnapshot> _getUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return await FirebaseFirestore.instance
            .collection("Profile_details")
            .doc(currentUser.uid)
            .get();
      }
      throw Exception("User not authenticated");
    } catch (e) {
      throw Exception("Error fetching user data:$e");
    }
  }

  TextEditingController? name2;
  TextEditingController? mail2;
  TextEditingController? number2;
  TextEditingController bio2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name2 = TextEditingController(text: widget.name);
    mail2 = TextEditingController(text: widget.email);
    number2 = TextEditingController(text: widget.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
        iconTheme: IconThemeData(color: Color(0xFFf4b017)),
        toolbarHeight: 100,
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: Column(
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: FutureBuilder<DocumentSnapshot>(
                    future: _getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error:${snapshot.error}");
                      } else {
                        final data = snapshot.data!;
                        final imageUrl = widget.url;
                        final number = widget.number;

                        if (imageUrl == null || imageUrl.isEmpty) {
                          return CircleAvatar(
                            minRadius: 70,
                          );
                        }
                        return CircleAvatar(
                          minRadius: 70,
                          backgroundImage: NetworkImage(imageUrl),
                        );
                      }
                    }),
              ),
              Positioned(
                left: 180,
                top: 300,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      _showBottomsheet(context);
                    },
                    icon: Icon(Icons.edit_outlined, color: Color(0xFFf4b017)),
                  ),
                ),
              )
            ]),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100),
              child: TextField(
                enabled: false,
                controller: name2,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                    color: Color(0xFFf4b017), fontWeight: FontWeight.bold),
                maxLines: null,
                decoration: InputDecoration(
                  // enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10)),
                  hintStyle: TextStyle(color: Color(0xFFf4b017)),
                  // border: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.black),
                  //     borderRadius: BorderRadius.circular(10)),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),

            // ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Profile_details")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No user found"),
              );
            }
            final users = snapshot.data!.docs;
            final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index].data() as Map<String, dynamic>;
                  final userId = users[index].id;
                  final name0 = userData["Name"] ?? "";
                  if (userId != currentUserUid) {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          final chatRoomId = currentUserUid! + userId;
                          final chatRoomRef = FirebaseFirestore.instance
                              .collection("chat_room")
                              .doc(chatRoomId);
                          final userRef = FirebaseFirestore.instance
                              .collection("Profile_details")
                              .doc(userId);
                          final chatRoomSnapshot = await chatRoomRef.get();
                          if (!chatRoomSnapshot.exists) {
                            await chatRoomRef.set({
                              "participants": [currentUserUid, userId],
                            });
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        receiverId: userId,
                                        chatroomid: chatRoomId,
                                        data: userData,
                                      )));
                        } catch (e) {
                          print("Error:$e");
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(name0),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                });
          }),
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
                  // onTap: getImageCamera,
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined),
                  title: Text("Choose from gallery"),
                  // onTap: pickAadharImage,
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  // onTap: pickAadharImage,
                ),
              ],
            ),
          );
        });
  }
}
