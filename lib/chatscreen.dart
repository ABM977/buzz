import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.data, this.chatroomid, required this.receiverId, this.imageurl});
  final data;
  final chatroomid;
  final String receiverId;
  final imageurl;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chats = TextEditingController();
  String receiverName = "";
  String image = "";
  bool isLoading = true;

  String docUrl = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    fetchReceiverData();
  }

  Future<void> fetchReceiverData() async {
    try {
      final receiverDoc =
      await FirebaseFirestore.instance.collection("Profile_details").doc(widget.receiverId).get();
      if (receiverDoc.exists) {
        setState(() {
          receiverName = receiverDoc.get("Name") ?? "";
          image = receiverDoc.get("ImageUrl") ?? "";
        });
      } else {
        print("Receiver document does not exist");
      }
    } catch (e) {
      print("Error fetching receiver's data: $e");
    }
  }

  String generateChatroomID(String uid1, String uid2) {
    final userIds = [uid1, uid2];
    userIds.sort();
    return userIds.join("_");
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final chatroomID = generateChatroomID(currentUserID, widget.receiverId);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: image.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(image)) : const Icon(Icons.person),
        ),
        title: Text(
          receiverName,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chat_room")
                  .doc(chatroomID)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final messages = snapshot.data!.docs[index].data();
                    final isCurrentUser = messages["senderId"] == currentUserID;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (messages["text"] != null) Text(messages["text"]),
                            // if (messages["chatimage"] != null) Image.network(messages["chatimage"]),
                            Text(
                              isCurrentUser ? "You" : receiverName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: chats,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (chats.text.isNotEmpty) {
                        try {
                          await FirebaseFirestore.instance
                              .collection("chat_room")
                              .doc(chatroomID)
                              .collection("messages")
                              .doc()
                              .set({
                            "text": chats.text,
                            "senderId": currentUserID,
                            "timestamp": Timestamp.now(),
                            "receiverId": widget.receiverId,
                            "chatimage": imageUrl.isNotEmpty ? imageUrl : "",
                          }).then((value) => {
                            FirebaseFirestore.instance.collection("chat_room").doc(chatroomID).set({
                              "room": chatroomID,
                              "time": DateTime.now(),
                            })
                          });
                          chats.clear();
                        } catch (e) {
                          print("Error sending message: $e");
                          // Show error message to user
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error sending message: $e"),
                          ));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
