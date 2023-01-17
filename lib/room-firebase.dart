import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/talk-room.dart';
import 'package:criander/model/user.dart';
import 'package:criander/user-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';

class RoomFireStore{
  static final FirebaseFirestore _firestoreInstance=FirebaseFirestore.instance;
  static final _roomCollection = _firestoreInstance.collection('room');
  static final joinedRoomSnapshot = _roomCollection.where('joined_user_ids',arrayContains: SharedPrefs.fetchUid()).snapshots();

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

  static Future<List<TalkRoom>?> fetchJoinedRooms(QuerySnapshot snapshot) async{
    try{
      String myuid = SharedPrefs.fetchUid()!;
      List<TalkRoom> TalkRooms = [];
      //ルームの数だけ繰り返す
      for(var doc in snapshot.docs){
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        List<dynamic>  userIds = data['joined_user_ids'];
        late String talkUsrUid;
        //ルームの中に入っているIDの数だけ繰り返す(2回)
        for(var id in userIds){
          if(id==myuid) continue;
          talkUsrUid =id;
        }
        User? talkUser = await UserFireStore.fetchProfile(talkUsrUid);
        if(talkUser==null) return null;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: data
            ['last_message']
        );
        TalkRooms.add(talkRoom);
      }

      print(TalkRooms.length);
      return TalkRooms;
    }catch(e){
      print('参加しているルームの取得に失敗しました ------- $e');
      return null;
    }
  }

  //メッセージを受け取る
  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomId){
    return _roomCollection.doc(roomId).collection('message').orderBy('send_time').snapshots();
  }

  //FireStoreに入力欄で入力した内容を格納
  static Future<void> sendMessage({required String roomId ,required String message}) async{
    try{
      final messageCollection = _roomCollection.doc(roomId).collection('message');
      await messageCollection.add({
        'message': message,
        'sender_id': SharedPrefs.fetchUid(),
        'send_time': Timestamp.now()
      });
    }catch(e){
      print('メッセージの送信失敗 --------- $e');
    }
  }
}