import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/admin_pages/PDFScreen.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:ffa_app/database.dart';
import 'package:path_provider/path_provider.dart';

class ViewMinutes extends StatefulWidget {

  @override
  _ViewMinutesState createState() => _ViewMinutesState();
}

class _ViewMinutesState extends State<ViewMinutes> {
  StorageReference firebaseStorageRef;
  File theFile;
  String theFilePath = "";
  String theFileType = "";

  Future<File> getImage() async {
    theFile = await FilePicker.getFile();
    return theFile;
  }

  DateTime _newDateTime;
  DateTime startDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("officer minutes").getDocuments();
    
    return qn.documents;
  }

    String startingDate;
    startingDate = _newDateTime == null ? "Date" : _newDateTime.month.toString() + "/" + _newDateTime.day.toString() + "/" + _newDateTime.year.toString();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ReturnButton(),
              Spacer(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 10, 0),
                child: RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Upload Document"),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: SizeConfig.blockSizeVertical * 35,
                                child: Column(
                                  children: <Widget>[
                                    Text("Enter Date of Officer Meeting: "),
                                    OutlineButton(
                                      hoverColor: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                                      child: Text(startingDate),
                                      onPressed: () async {
                                        _newDateTime = await showRoundedDatePicker(
                                          context: context,
                                          initialDate: startDate,
                                          lastDate: DateTime(DateTime.now().year + 1),
                                          borderRadius: 16,
                                          theme: ThemeData(primarySwatch: Colors.blue),
                                        );
                                        setState(() {
                                          startingDate = _newDateTime.month.toString() + "-" + _newDateTime.day.toString() + "-" + _newDateTime.year.toString();
                                        });
                                      },
                                    ),
                                    OutlineButton(
                                      hoverColor: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor, style: BorderStyle.solid, width: 3),
                                      child: Text("Select Document"),
                                      onPressed: () async {
                                        File theFile = await getImage();
                                        setState(() {
                                          theFilePath = theFile.path;
                                          theFileType = theFile.path.toString().substring(theFile.path.toString().length - 3);
                                        });
                                      },
                                    ),
                                    Center(child: Text(theFilePath))
                                  ],
                                ),
                              );
                            }
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("CANCEL")
                            ),
                            FlatButton(
                              onPressed: () async {
                                if(theFileType == "pdf" && _newDateTime != null) {
                                  Navigator.of(context).pop();
                                  firebaseStorageRef = FirebaseStorage.instance.ref().child(startingDate + '.pdf');
                                  final StorageUploadTask task = firebaseStorageRef.putFile(theFile);

                                  var url = await (await task.onComplete).ref.getDownloadURL();

                                  await OfficerMinutesService().addOfficerMinutes(startingDate, url.toString());

                                  setState(() {
                                    startingDate = "";
                                    theFilePath = "";
                                    _newDateTime = null;
                                  });
                                }
                                else {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Please make sure that you have a time and that your document is a pdf file"),
                                        actions: [
                                          FlatButton(
                                            onPressed: () => Navigator.of(context).pop(), 
                                            child: Text("BACK")
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                              },
                              child: Text("SUBMIT")
                            )
                          ],
                        );
                      }
                    );
                  },
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  child: Text("Upload Document", style: TextStyle(color: Theme.of(context).accentColor),),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(10)),
          FutureBuilder(
            future: getPosts(),
            builder: (_, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                return Container(
                  height: SizeConfig.blockSizeVertical * 65,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 5, 0, SizeConfig.blockSizeHorizontal * 5, 0),
                    itemBuilder: (_, index) {
                      return officerMinutesCard(snapshot.data[index], context);
                    }
                  ),
                );
              }
            }
          )
        ],
      ),
    );
  }

  Widget officerMinutesCard(DocumentSnapshot snapshot, BuildContext context) {
    String pathPDF = "";
    String pdfUrl = "";

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: SizeConfig.blockSizeVertical * 30,
          width: SizeConfig.blockSizeHorizontal * 90,
          child: GestureDetector(
            onTap: () async {
              await LaunchFile.loadFromFirebase(context, snapshot.data['date']).then((url) => LaunchFile.createFileFromPdfUrl(url, snapshot.data['date']).then((f) => setState(() {
                if(f is File) {
                  pathPDF = f.path;
                } else if(url is Uri) {
                  pdfUrl = url.toString();
                }
              })));
              setState(() {
                LaunchFile.launchPDF(context, "Officer Meeting Minutes -" + snapshot.data['date'], pathPDF, pdfUrl);
              });
            },
            child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3.5, 5, 3.5, 10),
                child: Column(
                  children: <Widget>[
                    Text("Officer Meeting Minutes - " + snapshot.data['date'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("Open Meeting Minutes", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, color: Theme.of(context).accentColor))
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class LaunchFile {
  static void launchPDF(BuildContext context, String title, String pdfPath, String pdfUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFScreen(title, pdfPath, pdfUrl)));
  }

  static Future<dynamic> loadFromFirebase(BuildContext context, String url) async {
    return await FirebaseStorage.instance.ref().child(url + ".pdf").getDownloadURL();
  }

  static Future<dynamic> createFileFromPdfUrl(dynamic url, String date) async {
    final filename = '$date.pdf';
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}