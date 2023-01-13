import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/talk-room.dart';
import 'package:criander/user-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';

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

  static Future<void> fetchJoinedRooms() async{
    try{
      String myuid = SharedPrefs.fetchUid()!;
      final snapshot = await _roomCollection.where('joined_user_ids',arrayContains: myuid).get();
      List<TalkRoom> TalkRooms = [];

    }catch(e){

    }
  }
}