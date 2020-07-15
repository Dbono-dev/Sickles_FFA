import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/feed_page.dart';
import 'package:ffa_app/profile_page.dart';
import 'package:ffa_app/event_view.dart';
import 'package:ffa_app/user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jiffy/jiffy.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
  }

  @override 
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    Future getPosts() async {
      var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection("events").orderBy('date').getDocuments();
      QuerySnapshot secondQn = await firestore.collection('club dates').orderBy('date').getDocuments();
      return secondQn.documents + qn.documents;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            ProfilePage(),
            FutureBuilder(
              future: getPosts(),
              builder: (_, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  return Column(
                    children: <Widget>[
                      MainPageBody(
                        snapshot: snapshot,
                      ),
                    ],
                  );
                }
              },
            ),
            FeedPage()
          ]
        ),
        bottomNavigationBar: SizedBox(
          height: SizeConfig.blockSizeVertical * 7.5,
            child: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.person, size: 25,),
                  text: "Profile",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.home, size: 25,),
                  text: "Home",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.dehaze, size: 25,),
                  text: "Feed",
                  iconMargin: EdgeInsets.all(0),
                )
              ],
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.transparent,
            ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MainPageBody extends StatefulWidget {

  MainPageBody({this.snapshot});

  final AsyncSnapshot<dynamic> snapshot;

  @override
  _MainPageBodyState createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {

  int _index = 0;
  DateFormat format = new DateFormat("MM-dd-yyyy");

  bool _clubDateNotWithin10Days(DocumentSnapshot snapshot) {
    DateTime theDateTime = format.parse(snapshot.data['date']);
    int _clubDate = Jiffy(theDateTime).dayOfYear;
    int _todayDate = Jiffy(DateTime.now()).dayOfYear;
    if((_clubDate - _todayDate) <= 10 && _clubDate >= _todayDate) {
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    String timeOfDay = "";
    int currentTime = DateTime.now().hour;
    
    if(currentTime > 4 && currentTime < 12) {
      timeOfDay = "Good Morning";
    }
    else if(currentTime >= 12 && currentTime < 16) {
      timeOfDay = "Good Afternoon";
    }
    else {
      timeOfDay = "Good Evening";
    }

    DateFormat format = new DateFormat("MM-dd-yyyy");
    DateFormat secondFormat = new DateFormat("yyyy-MM-dd");

    var theSnapshot = widget.snapshot.data;
    for(int i = 0; i < theSnapshot.length; i++) {
      DocumentSnapshot snapshot = theSnapshot[i];
      if(format.parse(snapshot.data['date']).isBefore(secondFormat.parse(DateTime.now().toString()))) {
        theSnapshot.remove(theSnapshot[i]);
      }
      if(snapshot.data['type'] == "clubDates" && _clubDateNotWithin10Days(snapshot)) {
        theSnapshot.remove(theSnapshot[i]);
      }
    }

    return Container(
      color: Colors.white,
      child: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if(snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2.5)),
                Text(timeOfDay, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold)),
                Text(userData.firstName, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.all(6)),
                Center(
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical * 60,
                    child: theSnapshot.length == 0 ? Center(child: Text("NO EVENTS", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 35),)) : PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: theSnapshot.length,
                      controller: PageController(viewportFraction: 0.825),
                      onPageChanged: (int theindex) => setState(() => _index = theindex),
                      itemBuilder: (_, i) {
                        return Container(
                          child: Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                              child: SizedBox(
                                height: SizeConfig.blockSizeVertical * 60,
                                child: eventCard(context, theSnapshot[_index], userData),
                              ),
                          ),
                        );
                      },
                    ),
                  )
                ),
              ]
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
      ),
    );
  }

  Widget eventCard(BuildContext context, DocumentSnapshot snapshot, UserData userData) {
    String startTimeBack;
    String endTimeBack;
    String startTime;
    String endTime;
    String title;
    String description;
    String location;

    if(snapshot.data['type'] != "clubDates") {
      startTime = snapshot.data['start time'].toString();
      endTime = snapshot.data['end time'].toString();

      int startTimeTest = int.parse(snapshot.data['start time'].toString().substring(0, 2));
      int startTimeMinutes = int.parse(snapshot.data['start time'].toString().substring(3));

      if(startTimeTest >= 12) {
        startTimeTest = startTimeTest - 12;
        startTimeBack = " pm";
        startTime = startTimeTest.toString() + startTime.substring(2);
      }
      else {
        startTimeBack = " am";
      }

      if(startTimeMinutes == 0) {
        startTime = startTimeTest.toString() + ":" + "00";
      }

      int endTimeTest = int.parse(snapshot.data['end time'].toString().substring(0, 2));
      int endTimeMinutes = int.parse(snapshot.data['end time'].toString().substring(3));

      if(endTimeTest >= 12) {
        endTimeTest = endTimeTest - 12;
        endTimeBack = " pm";
        endTime = endTimeTest.toString() + endTime.substring(2);
      }
      else {
        endTimeBack = " am";
      }

      if(endTimeMinutes == 0) {
        endTime = endTimeTest.toString() + ":" + "00";
      }
      title = snapshot.data['title'];
      description = snapshot.data['description'];
      location = snapshot.data['location'];
    }
    else {
      title = "Club Meeting";
      description = snapshot.data['agenda'];
      location = "Sickles High";
      startTime = "10:56";
      startTimeBack = "am";
      endTime = "11:31";
      endTimeBack = "am";
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewPage(snapshot: snapshot, userData: userData,)));
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 60,
        width: SizeConfig.blockSizeHorizontal * 75,   
        color: Colors.transparent,         
        child: Card(
          elevation: 10,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(width: 1, color: Colors.transparent)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget> [
                  Text(title, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Text(snapshot.data['date'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25)),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(snapshot.data['type'] == "clubDates" ? "Agenda" : "Description", 
                      style: TextStyle(
                        color: Colors.white, 
                        decoration: TextDecoration.underline)
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    height: SizeConfig.blockSizeVertical * 17.5,
                    child: SingleChildScrollView(
                      child: Text(
                        description, 
                        style: TextStyle(color: Colors.white, fontSize: 25), 
                        textAlign: TextAlign.center,
                      )
                    )
                  ),
                  Spacer(),
                  Text(location, style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),
                  Text(startTime + startTimeBack + " - " + endTime + endTimeBack, style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text("View Event", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35, decoration: TextDecoration.underline, fontWeight: FontWeight.bold))
                ]
              ),
            ),
          ),
        )
      ),
    );
  }
}