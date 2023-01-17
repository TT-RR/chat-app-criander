import 'dart:io';

import 'package:criander/model/user.dart';
import 'package:criander/user-firebase.dart';
import 'package:criander/utils/shared-prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? image;
  String imagePath = '';
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();

  Future<void> selectImage() async{
    //最後のところを.cameraにするとカメラが使える
    PickedFile? pickedImage = await _picker.getImage(source: ImageSource.gallery);

    if(pickedImage == null) return;

    setState((){
      //imageの中に選択した画像のpathを入れる
      image = File(pickedImage.path);
    });
  }

  Future<void> uploadImage() async{
    final ref = FirebaseStorage.instance.ref('test.png');
    final storedImage = await ref.putFile(image!);
    imagePath = await storedImage.ref.getDownloadURL();
    print(imagePath);
  }

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
              children: [
                const SizedBox(width: 150,child: Text('名前')),
                Expanded(child: TextField(
                    controller: controller,
                ))
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
                        onPressed: ()async{
                          await selectImage();
                          uploadImage();
                        },
                        child: const Text('画像を選択')),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30,),

            image == null   //imageの中がnullなら
              ? const SizedBox()  //何も表示しない
              : SizedBox(
                width: 200,
                height: 200,
                child: Image.file(image!,fit: BoxFit.cover,)
            ),
            const SizedBox(height: 50,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                  onPressed: () async{
                  User newProfile = User(
                      name: controller.text,
                      imagePath: imagePath,
                      uid: SharedPrefs.fetchUid()!
                  );
                  await UserFireStore.updateUser(newProfile);
                },
                  child: const Text('編集')),
            )
          ],
        ),
      ),
    );
  }
}
