import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otizm_destek_ve_bilgi_agi/chatg%C4%B1r%C4%B1s.dart';
import 'package:otizm_destek_ve_bilgi_agi/login.dart';
import 'package:otizm_destek_ve_bilgi_agi/profile.dart';
// WhatsAppMain widget'ını içe aktarın

class ChatScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String currentUserEmail;

  ChatScreen({
    required this.userId,
    required this.username,
    required this.currentUserEmail,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendMessage() async {
    try {
      final messageText = _messageController.text.trim();
      if (messageText.isNotEmpty) {
        await _firestore.collection('chats').add({
          'text': messageText,
          'sender': widget.currentUserEmail,
          'receiver': widget.userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      }
    } catch (e) {
      print('Mesaj gönderilirken hata oluştu: $e');
      // Kullanıcıya hata mesajını göstermek için bir dialog veya snackbar kullanabilirsiniz
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sohbetlerim ${widget.username}'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              try {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(
                          userId: ' ',
                          username: ' ',
                          currentUserEmail: 'currentEmail@gmail.com',
                        ),
                  ),
                );
              } catch (e) {
                print('Çıkış yapılırken hata oluştu: $e');
                // Kullanıcıya hata mesajını göstermek için bir dialog veya snackbar kullanabilirsiniz
              }
            },
          ),
        ],
      ),


body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('İLK MESAJ ATMAYA NE DERSİN :)'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data!.docs[index];
                      var username = user[' '];
                      var userId = user.id;

                      if (userId != _auth.currentUser!.uid) {
                        return ListTile(
                          title: Text(username),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  userId: userId,
                                  username: username,
                                  currentUserEmail: widget.currentUserEmail,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink(); // Kendi kullanıcısını gösterme
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(

                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
