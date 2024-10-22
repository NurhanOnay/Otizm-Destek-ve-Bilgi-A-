import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otizm_destek_ve_bilgi_agi/chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otizm_destek_ve_bilgi_agi/chatg%C4%B1r%C4%B1s.dart';


class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcılar'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0), // İsteğe bağlı: Liste kenar boşluğu ekleyebilirsiniz
        child: UsersList(),
      ),
    );
  }
}

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Henüz kullanıcı yok.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              var email = user['email'];
              var userId = user.id;

              return ListTile(
                title: Text(email),
                onTap: () {
                  // Tıklanan kullanıcıyla sohbet ekranını aç
                },
              );
            },
          );
        }
      },
    );
  }
}
