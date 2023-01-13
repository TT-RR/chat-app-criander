import 'package:criander/model/user.dart';
import 'package:criander/pages/setting-page.dart';
import 'package:criander/pages/talk-room-page.dart';
import 'package:flutter/material.dart';

//stfと入力し、クラス名を書く
//StatefullWidgetにカーソルを当て、電球のmaterial.dartクリック
class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<User> userList = [
    User(name: '田中',
        uid: 'abc',
        imagePath: 'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?fit=bounds&format=jpeg&quality=85&width=330'
        ,
        ),
    User(name: '星野',
        uid: 'def'
        ),
    User(name: '湯澤',
        uid: 'ghi',
        imagePath: 'https://res.cloudinary.com/alu/image/upload/v1656566479/hmp_images/lq92l0ivrx6qwjyhly0b.png',
        ),
  ];

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
      body: ListView.builder(
          //userList内の要素数だけトークン数を作成
          itemCount: userList.length,
          itemBuilder: (context, index) {
              //ウィジェットにカーソルをあわせ、電球をクリックすることで、スタイル設定できる
              return InkWell(
                //タップすると、
                onTap: (){
                  //class トークぺージルームに遷移
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)  => TalkRoomPage(userList[index].name)
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
                            backgroundImage: userList[index].imagePath ==  null
                                ? null    //nullなら何も表示しない
                                : NetworkImage(userList[index].imagePath!)    //nullじゃないならurlの画像表示
                        ),
                      ),

                      //Columnウィジェットは要素を縦に並べる
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userList[index].name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          Text('イエローハット',style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ],
                  ),
                ),
              );
          }
      ),
    );
  }
}
