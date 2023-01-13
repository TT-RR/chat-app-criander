import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/user.dart';
import 'package:criander/room-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';

class UserFireStore{
  static final FirebaseFirestore _firestoreInstance=FirebaseFirestore.instance;
  static final _userCollection = _firestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async{
    //実行して、
    try{
      //newDocにnameとimage_pathも入れる
      final newDoc = await _userCollection.add({
        'name':'名無し',
        'image_path':'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?fit=bounds&format=jpeg&quality=85&width=330',
      });
      print('アカウント作成完了');
      return newDoc.id;
    }catch(e){
      //うまくいかないならこっちに行く
      print('アカウント作成失敗 --- $e');
      return null;
    }
  }

  //uidがnullの時、実行される
  static Future<void> createUser() async{
    //新しいアカウントを作成
    final myUid = await UserFireStore.insertNewAccount();
    //IDを作れたら、トークルーム作成
    if(myUid != null){
      await RoomFireStore.addRoom(myUid);
      //端末に保存
      await SharedPrefs.setUid(myUid);
    }
  }

  //クラウドに保存してある全ての情報を取ってくる
  static Future<List<QueryDocumentSnapshot>?> fetchUser() async{
    try{
      final snapshot = await _userCollection.get();
      //データベース/コレクション/ドキュメントの取得
      return snapshot.docs;
    }catch(e){
      print('ユーザ情報取得失敗 --- $e');
      return null;
    }
  }

  //クラウドに保存してあるユーザの情報を取ってくる
  static Future<User?> fetchProfile(String uid) async{
      try{
        final snapshot = await _userCollection.doc(uid).get();
        User user = User(
          name: snapshot.data()!['name'],
          imagePath: snapshot.data()!['image-path'],
          uid: uid
        );
        return user;
      }catch(e){
        print('自分のユーザ情報取得失敗 --- $e');
        return null;
      }
  }
}