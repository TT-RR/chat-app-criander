import 'package:criander/model/message.dart';
import 'package:flutter/material.dart';
//頭にintlとついている文だけ適応
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final String name;
  const TalkRoomPage(this.name,{Key? key}) : super(key: key);

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  //List内の例
  List<Message> messageList=[
    Message(message: 'aaa', isMe: true, sendTime: DateTime(2023,1,7,20,40)),
    Message(message: 'sss', isMe: false, sendTime: DateTime(2023,1,7,20,41)),
    Message(message: 'ｖｈｄｓぎぇｄｖんｆｋうぇ、ｃぺをｇｊひｒんｇせｔｆｙｆｔｆｘｒｆｔじゅｆｙんｊんｊｙｖｆｘｄｒｇｄｘｙｋｂｋｂｈｈぐｆぇｘｔｇｈｙｄつぇｓ', isMe: false, sendTime: DateTime(2023,1,7,20,41)),
    Message(message: 'aaa', isMe: true, sendTime: DateTime(2023,1,7,20,40)),
    Message(message: 'ｖｈｄｓぎぇｄｖんｆｋうぇ、ｃぺをｇｊひｒんｇせｔｆｙｆｔｆｘｒｆｔじゅｆｙんｊんｊｙｖｆｘｄｒｇｄｘｙｋｂｋｂｈｈぐｆぇｘｔｇｈｙｄつぇｓ', isMe: false, sendTime: DateTime(2023,1,7,20,41)),
    Message(message: 'aaa', isMe: true, sendTime: DateTime(2023,1,7,20,40)),
    Message(message: 'ｖｈｄｓぎぇｄｖんｆｋうぇ、ｃぺをｇｊひｒんｇせｔｆｙｆｔｆｘｒｆｔじゅｆｙんｊんｊｙｖｆｘｄｒｇｄｘｙｋｂｋｂｈｈぐｆぇｘｔｇｈｙｄつぇｓ', isMe: false, sendTime: DateTime(2023,1,7,20,41)),
    Message(message: 'aaa', isMe: true, sendTime: DateTime(2023,1,7,20,40)),
    Message(message: 'ｖｈｄｓぎぇｄｖんｆｋうぇ、ｃぺをｇｊひｒんｇせｔｆｙｆｔｆｘｒｆｔじゅｆｙんｊんｊｙｖｆｘｄｒｇｄｘｙｋｂｋｂｈｈぐｆぇｘｔｇｈｙｄつぇｓ', isMe: false, sendTime: DateTime(2023,1,7,20,41)),
    Message(message: 'aaa', isMe: true, sendTime: DateTime(2023,1,7,20,40)),
    Message(message: 'ｖｈｄｓぎぇｄｖんｆｋうぇ、ｃぺをｇｊひｒんｇせｔｆｙｆｔｆｘｒｆｔじゅｆｙんｊんｊｙｖｆｘｄｒｇｄｘｙｋｂｋｂｈｈぐｆぇｘｔｇｈｙｄつぇｓ', isMe: false, sendTime: DateTime(2023,1,7,20,41)),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(widget.name),
      ),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //トーク画面
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: ListView.builder(
                //一画面で収まるときは、スクロールできない
                physics: const RangeMaintainingScrollPhysics(),
                itemCount: messageList.length,
                itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10,bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        //送られたメッセージが自分なら右(Yes)、相手なら左(No)
                        textDirection: messageList[index].isMe  ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                              decoration: BoxDecoration(
                                  color: messageList[index].isMe  ? Colors.green : Colors.white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                              child: Text(messageList[index].message)
                          ),
                          Text(intl.DateFormat('HH:mm').format(messageList[index].sendTime))
                        ],
                      ),
                    );
                  }
                ),
          ),
          //送信画面
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      decoration: InputDecoration(    //入力画面の
                        border: OutlineInputBorder()  //アウトラインに線を引く
                      ),
                    )),
                    IconButton(onPressed: (){

                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          )
        ],
      ),
    );
  }
}
