import 'package:flutter/material.dart';
import 'package:otizm_destek_ve_bilgi_agi/butongiris.dart';
import 'package:firebase_core/firebase_core.dart';import 'firebase_options.dart';// ...
import 'package:otizm_destek_ve_bilgi_agi/yenıhesap.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized(); //widget baglantısı
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
 ));
 }



