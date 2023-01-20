import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/message.dart';
import 'package:criander/model/talk-room.dart';
import 'package:criander/room-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';
import 'package:flutter/material.dart';
//頭にintlとついている文だけ適応
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final TalkRoom talkRoom;
  const TalkRoomPage(this.talkRoom,{Key? key}) : super(key: key);

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  //入力欄の文字を受け取る
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(widget.talkRoom.talkUser.name),
      ),

      body: Stack(
        children: [
          //トーク画面
          StreamBuilder<QuerySnapshot>(
            stream: RoomFireStore.fetchMessageSnapshot(widget.talkRoom.roomId),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: ListView.builder(
                    //一画面で収まるときは、スクロールできない
                      physics: const RangeMaintainingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length ,
                      itemBuilder: (context,index){
                        final doc = snapshot.data!.docs[index];
                        final Map<String , dynamic> data = doc.data() as Map<String , dynamic>;
                        final Message message = Message(
                            message: data['message'],
                            //自分のIDとsender_idが同じならtrue
                            isMe: SharedPrefs.fetchUid() == data['sender_id'],
                            sendTime: data['send_time']
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10,bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            //送られたメッセージが自分なら右(Yes)、相手なら左(No)
                            textDirection: message.isMe  ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                                  decoration: BoxDecoration(
                                      color: message.isMe  ? Colors.green : Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  child: Text(message.message)
                              ),
                              Text(intl.DateFormat('HH:mm').format(message.sendTime.toDate()))
                            ],
                          ),
                        );
                      }
                  ),
                );
              }
              else{
                return const Center(child: Text('メッセージがありません'),);
              }

            }
          ),

          //送信画面
          Column(
            //入力欄を一番下に
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(    //入力画面の
                          border: OutlineInputBorder()  //アウトラインに線を引く
                      ),
                    )),
                    IconButton(
                      onPressed: () async {
                        await RoomFireStore.sendMessage(
                            roomId: widget.talkRoom.roomId,
                            message: controller.text
                        );
                        controller.clear();
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
