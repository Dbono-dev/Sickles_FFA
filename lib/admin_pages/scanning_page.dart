import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:ffa_app/admin_pages/scanned_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanningPage extends StatefulWidget {

  ScanningPage({this.scanUID, this.scanName, this.scanDate, this.scanEvent});

  final List scanUID;
  final List scanName;
  final List scanDate;
  final List scanEvent;

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {

  String qrCodeResult;
  List theScanUID = new List();
  List theScanName = new List();
  List theScanDate = new List();
  List theScanEvent = new List();

  @override
  Widget build(BuildContext context) {

    if(widget.scanUID != null) {
      theScanUID = widget.scanUID;
      theScanName = widget.scanName;
      theScanDate = widget.scanDate;
      theScanEvent = widget.scanEvent;
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        height: SizeConfig.blockSizeVertical * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            ReturnButton(),
            Container(
              height: SizeConfig.blockSizeVertical * 65,
              child: ListView.builder(
                itemCount: theScanUID.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(theScanName[index]),
                      trailing: Icon(Icons.check, color: Colors.green),
                    )
                  );
                }
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    return RaisedButton(
                      elevation: 10,
                      color: Colors.white,
                      onPressed: () async {
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        String text = "";
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Saving...", style: TextStyle(color: Theme.of(context).accentColor)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 8,
                        ));
                        List<String> largeStringList = new List<String>();
                        if(sharedPreferences.getStringList("scannedData") != null) {
                          largeStringList = sharedPreferences.getStringList("scannedData");
                        }
                        for(int i = 0; i < theScanUID.length; i++) {
                          text += theScanEvent[i];
                          text += "/" + theScanUID[i];
                          text += "/" + theScanName[i];
                          text += "/" + theScanDate[i] + "/";
                        }
                        largeStringList.add(text);
                        sharedPreferences.setStringList('scannedData', largeStringList);
                        setState(() {
                          theScanUID.clear();
                          theScanName.clear();
                          theScanDate.clear();
                          theScanEvent.clear();
                        });
                      },
                      child: Text("Save"),
                    );
                  }
                ),
                Builder(
                  builder: (context) {
                    return RaisedButton(
                      elevation: 10,
                      color: Colors.white,
                      onPressed: () async {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Submitting...", style: TextStyle(color: Theme.of(context).accentColor)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 8,
                        ));
                        for(int i = 0; i < theScanUID.length; i++) {
                          String text = "";
                          text += theScanEvent[i];
                          text += "/" + theScanUID[i];
                          text += "/" + theScanName[i];
                          text += "/" + theScanDate[i];
                          await ScannedData(text: text, date: theScanDate[i]).submitScanningSession();
                        }
                        setState(() {
                          theScanUID.clear();
                          theScanName.clear();
                          theScanDate.clear();
                          theScanEvent.clear();
                        });
                      },
                      child: Text("Submit"),
                    );
                  }
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 0.5),),
            Material(
              type: MaterialType.transparency,
              child: Container(
              height: 50,
              width: SizeConfig.blockSizeHorizontal * 100,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Colors.black,
                  blurRadius: 15.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 10.0)
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: FlatButton(
                onPressed: () async {
                  var result = await BarcodeScanner.scan();
                  HapticFeedback.vibrate();
                  List theListOfData = await ScannedData(text: result.rawContent, date: DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString()).resisterScanData();
                  setState(() {
                    theScanUID.add(theListOfData[1]);
                    theScanName.add(theListOfData[2]);
                    theScanDate.add(theListOfData[3]);
                    theScanEvent.add(theListOfData[0]);
                  });
                },
              child: Text("Scan", textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor
                  )),
              ),
            ),
            )
          ]
        ),
      ),
    );
  }
}