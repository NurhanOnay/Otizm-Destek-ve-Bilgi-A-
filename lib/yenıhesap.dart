import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otizm_destek_ve_bilgi_agi/chat.dart'; // ChatScreen'i içe aktarın


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _register(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Kullanıcı Firestore'a kaydediliyor
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': _emailController.text,
        // Diğer kullanıcı bilgileri buraya eklenebilir
      });
      // Hesap oluşturma başarılı
      print("Hesap oluşturma başarılı: ${userCredential.user?.email ?? 'Bilgi yok'}");

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorDialog(context, 'Şifre çok zayıf.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog(context, 'Bu e-posta zaten kullanımda.');
      } else {
        _showErrorDialog(context, 'Bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Bir hata oluştu: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Hesap Oluştur'),
        backgroundColor: Colors.blue, // AppBar rengi
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email), // E-posta ikonu
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock), // Kilit ikonu
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _register(context), // _register işlevini çağırın
              child: Text('Kayıt Ol'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[500],
                foregroundColor: Colors.white, // Düğme rengi
              ),
            ),

          ],
        ),
      ),
    );
  }
}
