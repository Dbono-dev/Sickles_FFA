import 'package:ffa_app/admin_pages/scanning_page.dart';
import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ffa_app/admin_pages/scanned_data.dart';

class ViewSavedScanningSessions extends StatefulWidget {
  @override
  _ViewSavedScanningSessionsState createState() => _ViewSavedScanningSessionsState();
}

class _ViewSavedScanningSessionsState extends State<ViewSavedScanningSessions> {
  List theList = new List();

  SharedPreferences sharedPreferences;

  Future getSavedEvents() async {
    sharedPreferences = await SharedPreferences.getInstance();
    theList = sharedPreferences.getStringList('scannedData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: getSavedEvents(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ReturnButton(),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        child: theList == null || theList.length == 0 ? Text("NO SAVED SCANNING SESSIONS", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,) : 
                        Container(
                          height: SizeConfig.blockSizeVertical * 70,
                          child: ListView.builder(
                            itemCount: theList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              return savedScanningSessionCards(theList[index], context, index);
                            }
                          ),
                        )
                      ),
                    ),
                  )
                ],
              );
            }
          }
        ),
      ),
    );
  }

  Widget savedScanningSessionCards(String data, BuildContext context, int index) {

    List<String> qrCodeItems = new List<String>(); 
    List theScanUID = new List();
    List theScanName = new List();
    List theScanDate = new List();
    List theScanEvent = new List();

    for(int i = 0; i < data.length; i++) {
      if(data.substring(0, i).contains("/")) {
        qrCodeItems.add(data.substring(0, i - 1));
        data = data.substring(i);
        i = 0;
      }
      else if(i == data.length - 1) {
        qrCodeItems.add(data);
      }
    }

    String date = qrCodeItems[3].substring(0, qrCodeItems[3].length - 1);
    String name = qrCodeItems[0];

    for(int i = 0; i < qrCodeItems.length; i++) {
      theScanUID.add(qrCodeItems[i + 1]);
      theScanDate.add(qrCodeItems[i + 3].substring(0, qrCodeItems[i + 3].length - 1));
      theScanEvent.add(qrCodeItems[i]);
      theScanName.add(qrCodeItems[i + 2]);
      qrCodeItems.removeRange(0, 3);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Card(
        elevation: 10,
        child: ListTile(
          title: Text(name + " " + date, textAlign: TextAlign.center,),
          trailing: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 47,
            child: Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanningPage(scanDate: theScanDate, scanEvent: theScanEvent, scanName: theScanName, scanUID: theScanUID)));
                  }, 
                  child: Text("Edit", style: TextStyle(color: Theme.of(context).accentColor))
                ),
                Builder(
                  builder: (context) {
                    return FlatButton(
                      onPressed: () async {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Submitting...", style: TextStyle(color: Theme.of(context).accentColor)),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 3),
                        ));
                        for(int i = 0; i < theScanUID.length; i++) {
                          String text = "";
                          text += theScanEvent[i];
                          text += "/" + theScanUID[i];
                          text += "/" + theScanName[i];
                          text += "/" + theScanDate[i];
                          await ScannedData(text: text, date: DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString()).submitScanningSession();
                        }
                        setState(() {
                          theList.removeAt(index);
                          sharedPreferences.setStringList('scannedData', theList);
                        });
                      }, 
                      child: Text("Submit", style: TextStyle(color: Theme.of(context).accentColor))
                    );
                  }
                )
              ],
            ),
          )
        )
      ),
    );
  }
}