import 'package:criander/model/user.dart';

class TalkRoom{
  String roomId;  //ルームID
  User talkUser;  //相手ユーザ
  String lastMessage;

  TalkRoom({
    required this.roomId,
    required this.talkUser,
    this.lastMessage = ''
  });
}