import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criander/model/talk-room.dart';
import 'package:criander/model/user.dart';
import 'package:criander/pages/setting-page.dart';
import 'package:criander/pages/talk-room-page.dart';
import 'package:criander/room-firebase.dart';
import 'package:flutter/material.dart';

//stfと入力し、クラス名を書く
//StatefullWidgetにカーソルを当て、電球のmaterial.dartクリック
class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャットアプリ'),
        actions: [
          //設定(歯車)アイコンボタン
          IconButton(
              onPressed: (){
                //クリックすると設定画面に飛ぶ
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)  => const SettingPage()
                ));

              },
              icon: const Icon(Icons.settings))
        ],
      ),

      //ボディ
      body: StreamBuilder<QuerySnapshot>(
        stream: RoomFireStore.joinedRoomSnapshot,
        builder: (context, streamsnapshot) {
          if(streamsnapshot.hasData){
            return FutureBuilder<List<TalkRoom>?>(
                future: RoomFireStore.fetchJoinedRooms(streamsnapshot.data!),
                builder: (context ,futureSnapshot) {
                  if(futureSnapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else{
                    if(futureSnapshot.hasData){
                      List<TalkRoom> talkRooms = futureSnapshot.data!;
                      return ListView.builder(
                        //userList内の要素数だけトークン数を作成
                          itemCount: talkRooms.length,
                          itemBuilder: (context, index) {
                            //ウィジェットにカーソルをあわせ、電球をクリックすることで、スタイル設定できる
                            return InkWell(
                              //タップすると、
                              onTap: (){
                                //class トークぺージルームに遷移
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)  => TalkRoomPage(talkRooms[index])
                                ));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Row(
                                  children: [
                                    //アカウント画像
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: talkRooms[index].talkUser.imagePath ==  null
                                              ? null    //nullなら何も表示しない
                                              : NetworkImage(talkRooms[index].talkUser.imagePath!)    //nullじゃないならurlの画像表示
                                      ),
                                    ),

                                    //Columnウィジェットは要素を縦に並べる
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(talkRooms[index].talkUser.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                        Text(talkRooms[index].lastMessage ?? '',style: TextStyle(color: Colors.grey),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                    else{
                      return const Center(child: Text('トークルームの取得に失敗しました'));
                    }
                  }

                }
            );
          }
         else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
