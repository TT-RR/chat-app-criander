import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/talk-room.dart';
import 'package:criander/model/user.dart';
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
      //データベースのルームの情報を取ってくる
      final snapshot = await _roomCollection.where('joined_user_ids',arrayContains: myuid).get();
      List<TalkRoom> TalkRooms = [];
      //ルームの数だけ繰り返す
      for(var doc in snapshot.docs){
        List<dynamic>  userIds = doc.data()['joined_user_ids'];
        late String talkUsrUid;
        //ルームの中に入っているIDの数だけ繰り返す(2回)
        for(var id in userIds){
          if(id==myuid) return;
          talkUsrUid =id;
        }
        User? talkUser = await UserFireStore.fetchProfile(talkUsrUid);
        if(talkUser==null) return;
        final talkRoom = TalkRoom(roomId: doc.id, talkUser: talkUser);
      }

    }catch(e){

    }
  }
}