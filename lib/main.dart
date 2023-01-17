import 'package:criander/model/user.dart';
import 'package:criander/pages/top-page.dart';
import 'package:criander/room-firebase.dart';
import 'package:criander/user-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


//まず1番最初に呼ばれる
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.setPrefsInstance();
  //uidかnullが返される
  String? uid = SharedPrefs.fetchUid();
  if(uid==null) await UserFireStore.createUser();
  runApp(const MyApp());
}

//stと打ち、stlessを選択
//1.StatelessWidget classが１番基本のUI
class MyApp extends StatelessWidget {
  //2.StatelessWidgetを継承( extends )したクラスを作成

  const MyApp({super.key});

  @override

  //3.buildメソッドでそのUI構築に必要なWidgetを組み合わせて組んだWidgetツリーを return で返す
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}

