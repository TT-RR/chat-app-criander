import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message;   //どんなメッセージ
  bool isMe;        //trueなら自分のメッセージ
                    //flaseなら相手のメッセージ
  Timestamp sendTime;//日付

  Message({
    required this.message,
    required this.isMe,
    required this.sendTime,
});
}