import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              //名前編集欄
              children: const [
                SizedBox(width: 150,child: Text('名前')),
                Expanded(child: TextField())
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              //画像編集欄
              children: [
                SizedBox(width: 150, child: Text('プロフィール画像')),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: (){

                        }, child: const Text('画像を選択')),
                  ),
                )
              ],
            ),
            const SizedBox(height: 50,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(onPressed: (){

                }, child: const Text('編集')),
            )
          ],
        ),
      ),
    );
  }
}
