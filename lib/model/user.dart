//ユーザ情報
class User {
  String name;        //ユーザの名前
  String uid;         //ユーザのID
  String? imagePath;  //ユーザのサイトURL

  User({
    required this.name, //必須内容
    required this.uid,  //必須内容
    this.imagePath,     //どちらでも
});
}