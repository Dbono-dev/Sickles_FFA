
class ScannedData {

  ScannedData({this.text, this.date});

  String text;
  String date;
  List<String> qrCodeItems = new List<String>(); 
  String title;
  String name;
  String time;
  String type;
  String uid;
  String oldDate;
  List participates = new List();
  String theText = "";

  Future<List> resisterScanData() async {
    for(int i = 0; i < text.length; i++) {
      var char = text[i];
      int temp = char.codeUnitAt(0) - 5;
      String theTemp = String.fromCharCode(temp);
      theText += theTemp;
    }

    for(int i = 0; i < theText.length; i++) {
      if(theText.substring(0, i).contains("/")) {
        qrCodeItems.add(theText.substring(0, i - 1));
        theText = theText.substring(i);
        i = 0;
      }
      else if(i == theText.length - 1) {
        qrCodeItems.add(theText);
      }
    }

    qrCodeItems.add(date);

    title = qrCodeItems[0];
    name = qrCodeItems[2];
    uid = qrCodeItems[1];

    return qrCodeItems;

  }
}