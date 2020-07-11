import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:ffa_app/admin_pages/scanned_data.dart';

class ScanningPage extends StatefulWidget {
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
    return Container(
      color: Colors.white,
      height: SizeConfig.blockSizeVertical * 72,
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
              RaisedButton(
                elevation: 10,
                color: Colors.white,
                onPressed: () {

                },
                child: Text("Save"),
              ),
              RaisedButton(
                elevation: 10,
                color: Colors.white,
                onPressed: () {

                },
                child: Text("Submit"),
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
                print(theListOfData);
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
    );
  }
}