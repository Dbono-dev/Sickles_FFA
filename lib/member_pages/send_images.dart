import 'dart:io';

import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendImages extends StatefulWidget {

  SendImages({this.name});

  final String name;

  @override
  _SendImagesState createState() => _SendImagesState();
}

class _SendImagesState extends State<SendImages> {
  StorageReference firebaseStorageRef;

  List<File> theImages = new List<File>();

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    File theFile = File(tempImage.path);
    print(tempImage.path);
    setState(() {
      theImages.add(theFile);
    });
  }

  Future sendImages() async {
    List theImagesUrl = new List();
    for(int i = 0; i < theImages.length; i++) {
      firebaseStorageRef = FirebaseStorage.instance.ref().child(widget.name + DateTime.now().toString());
      final StorageUploadTask task = firebaseStorageRef.putFile(theImages[i]);

      if(theImages.length == 1) {
        var test = await (await task.onComplete).ref.getDownloadURL();
        await UploadedPictures().addPic(test.toString(), widget.name);
      }
      else {
        var test = await (await task.onComplete).ref.getDownloadURL();
        theImagesUrl.add(test.toString());
      }
    }
    if(theImages.length > 1) {
      await UploadedPictures().addPics(theImagesUrl, widget.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ReturnButton(),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 450,
              width: SizeConfig.blockSizeHorizontal * 85,
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5)),
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        await getImage();
                      },
                      child: Text("Add Images", )
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    theImages.length == 0 ? Center(child: Text("NO IMAGES", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35))) : SizedBox(
                      height: 344,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: theImages.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Image.file(theImages[i], height: 150,),
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          Center(
            child: Container(
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeHorizontal * 45,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).primaryColor),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  await sendImages();
                  setState(() {
                    theImages.clear();
                  });
                },
                child: Text("Send Images", style: TextStyle(color: Theme.of(context).accentColor),)
              ),
            ),
          )
        ],
      ),
    );
  }
}