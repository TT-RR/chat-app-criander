import 'package:cloud_firestore/cloud_firestore.dart';

class UserFireStore{
  static final FirebaseFirestore _firestoreInstance=FirebaseFirestore.instance;
  static final _userCollection = _firestoreInstance.collection('user');

  static Future<String?> addUser() async{
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
}