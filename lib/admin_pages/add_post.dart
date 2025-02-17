import 'package:ffa_app/database.dart';
import 'package:ffa_app/main.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/size_config.dart';

class AddPost extends StatefulWidget {

  AddPost({this.title, this.description, this.link, this.edit, this.dateTime, this.oGTitle});

  final String title;
  final String oGTitle;
  final String description;
  final String link;
  final bool edit;
  final String dateTime;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final _addPostFormKey = GlobalKey<FormState>();
  String _title;
  String _description;
  String _link;
  String add_save_post = "Add Post";

  @override
  Widget build(BuildContext context) {

    if(widget.title != null) {
      _title = widget.title;
      _description = widget.description;
      _link = widget.link;
      add_save_post = "Save Post";
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.blockSizeVertical * 100,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    ReturnButton(),
                    Padding(padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 4, 0, 0)),
                    Center(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 65,
                        width: SizeConfig.blockSizeHorizontal * 90,
                        child: Form(
                          key: _addPostFormKey,
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget> [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, SizeConfig.blockSizeVertical * 4, SizeConfig.blockSizeHorizontal * 4.8, 0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Title',
                                    ),
                                      onChanged: (val) => _title = (val),
                                      onSaved: (val) => _title = (val),
                                      validator: (val) => val.isEmpty ? 'Enter Title' : null,
                                      initialValue: _title,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, SizeConfig.blockSizeVertical * 2, SizeConfig.blockSizeHorizontal * 4.8, 0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Description',
                                    ),
                                      onChanged: (val) => _description = (val),
                                      onSaved: (val) => _description = (val),
                                      validator: (val) => val.isEmpty ? 'Enter Description' : null,
                                      minLines: 3,
                                      maxLines: 6,
                                      initialValue: _description,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal * 4.8, SizeConfig.blockSizeVertical * 2, SizeConfig.blockSizeHorizontal * 4.8, 0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Link',
                                    ),
                                      onChanged: (val) => _link = (val),
                                      onSaved: (val) => _link = val,
                                      initialValue: _link,
                                    ),
                                  ),
                                ),
                                
                              ]
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 68, 0, 0),
                  height: SizeConfig.blockSizeVertical * 7,
                  width: SizeConfig.blockSizeHorizontal * 45,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).accentColor),
                  child: Builder(
                    builder: (context) {
                      return FlatButton(
                        onPressed: () async {
                          var currentState = _addPostFormKey.currentState;
                          currentState.save();
                          if(currentState.validate()) {
                            if(widget.edit == true) {
                              await PostService().savePost(
                                oldTitle: widget.oGTitle,
                                title: _title,
                                description: _description,
                                link: _link == null ? "" : _link,
                                dateTime: widget.dateTime
                              );
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            else {
                              if(_link == null) {
                                await PostService().addPostWithoutLink(title: _title, description: _description);
                                setState(() {
                                  _title = "";
                                  _description = "";
                                  _link = "";
                                });
                              }
                              else {
                                await PostService().addPost(title: _title, description: _description, link: _link);
                                setState(() {
                                  _title = "";
                                  _description = "";
                                  _link = "";
                                });
                              }
                            }
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Added Post", style: TextStyle(color: Theme.of(context).accentColor),),
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 8,
                                duration: Duration(seconds: 3),
                              )
                            );
                          }
                        },
                        child: Text(add_save_post, style: TextStyle(color: Theme.of(context).primaryColor),)
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}