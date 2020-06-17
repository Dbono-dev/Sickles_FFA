import 'package:ffa_app/main.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';

class ExportData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: SizeConfig.blockSizeVertical * 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: Center(
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {

                  },
                  child: Text("Export Data", style: TextStyle(color: Theme.of(context).accentColor),),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}