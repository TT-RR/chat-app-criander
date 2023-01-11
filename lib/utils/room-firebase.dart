import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/utils/user-firebase.dart';

class RoomFireStore{
  static final FirebaseFirestore _firestoreInstance=FirebaseFirestore.instance;
  static final _roomCollection = _firestoreInstance.collection('room');

  //自分のIDと一致したときだけ、トークルーム作成
  static Future<void> addRoom(String myUid) async{
    try{
      final docs=await UserFireStore.fetchUser();
      if(docs == null) return;
      docs.forEach((doc) async{
        if(doc.id==myUid) return;
        await _roomCollection.add({
          'joined_user_ids': [doc.id,myUid],
          'created_time': Timestamp.now()
        });

      });
    }catch(e){
      print('ルーム作成失敗 ------- $e');
    }

  }
}