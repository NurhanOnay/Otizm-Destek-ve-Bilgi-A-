import 'package:flutter/material.dart';
import 'package:otizm_destek_ve_bilgi_agi/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otizm_destek_ve_bilgi_agi/chatg%C4%B1r%C4%B1s.dart';
import 'package:otizm_destek_ve_bilgi_agi/k%C4%B1s%C4%B1ler.dart';
import 'package:otizm_destek_ve_bilgi_agi/yenıhesap.dart';
import 'package:otizm_destek_ve_bilgi_agi/kısıler.dart';



class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Giriş başarılı, ChatScreen'e yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WhatsAppMain()),
      );
    } catch (e) {
      // Giriş başarısız, hata mesajı göster
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Giriş yapılırken bir hata oluştu: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Ekranı'),
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
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signIn(context),
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text('Yeni Hesap Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}




