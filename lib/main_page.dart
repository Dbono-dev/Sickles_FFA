import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/events.dart';
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
    List<Events> theEventsList = new List<Events>();

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
                  for(int i = 0; i < snapshot.data.length; i++) {
                    theEventsList.add(
                      Events(
                        title: snapshot.data[i].data['title'],
                        date: snapshot.data[i].data['date'],
                        description: snapshot.data[i].data['description'],
                        location: snapshot.data[i].data['location'],
                        startTime: snapshot.data[i].data['start time'],
                        endTime: snapshot.data[i].data['end time'],
                        type: snapshot.data[i].data['type'],
                        agenda: snapshot.data[i].data['agenda'] != null ? snapshot.data[i].data['agenda'] : "",
                        participates: snapshot.data[i].data['participates'],
                        participatesInfo: snapshot.data[i].data['participates info'],
                        participatesName: snapshot.data[i].data['participates name'],
                        maxParticipates: snapshot.data[i].data['max participates'],
                        key: snapshot.data[i].data['key'],
                        informationDialog: snapshot.data[i].data['information dialog']
                    ));
                  }
  
                  DateFormat format = new DateFormat("MM-dd-yyyy");
                  DateFormat secondFormat = new DateFormat("yyyy-MM-dd");

                  bool _clubDateNotWithin10Days(Events snapshot) {
                    DateTime theDateTime = format.parse(snapshot.date);
                    int _clubDate = Jiffy(theDateTime).dayOfYear;
                    int _todayDate = Jiffy(DateTime.now()).dayOfYear;
                    if((_clubDate - _todayDate) <= 10 && _clubDate >= _todayDate) {
                      return false;
                    }
                    else {
                      return true;
                    }
                  }

                  for(int i = 0; i < theEventsList.length; i++) {
                    Events snapshot = theEventsList[i];
                    if(format.parse(snapshot.date).isBefore(secondFormat.parse(DateTime.now().toString()))) {
                      theEventsList.remove(snapshot);
                    }
                    if(snapshot.type == "clubDates" && _clubDateNotWithin10Days(snapshot)) {
                      theEventsList.remove(snapshot);
                    }
                  }

                  if(theEventsList != null) {
                    return MainPageBody(
                      theEventList: theEventsList,
                    );
                  }
                  else {
                    return Text("NO EVENTS", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 35),);
                  }
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

  MainPageBody({this.theEventList});

  final List<Events> theEventList;

  @override
  _MainPageBodyState createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {

  int _index = 0;

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
                Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 3)),
                Text(timeOfDay, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold)),
                Text(userData.firstName, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.all(6)),
                Center(
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical * 60,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.theEventList.length,
                      controller: PageController(viewportFraction: 0.825),
                      onPageChanged: (int theindex) => setState(() => _index = theindex),
                      itemBuilder: (_, i) {
                        return Container(
                          child: Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                              child: SizedBox(
                                height: SizeConfig.blockSizeVertical * 60,
                                child: eventCard(context, widget.theEventList[_index], userData),
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

  Widget eventCard(BuildContext context, Events event, UserData userData) {
    String startTimeBack;
    String endTimeBack;
    String startTime;
    String endTime;
    String title;
    String description;
    String location;

    if(event.type != "clubDates") {
      startTime = event.startTime.toString();
      endTime = event.endTime.toString();

      int startTimeTest = int.parse(event.startTime.toString().substring(0, 2));
      int startTimeMinutes = int.parse(event.startTime.toString().substring(3));

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

      int endTimeTest = int.parse(event.endTime.toString().substring(0, 2));
      int endTimeMinutes = int.parse(event.endTime.toString().substring(3));

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
      title = event.title;
      description = event.description;
      location = event.location;
    }
    else {
      title = "Club Meeting";
      description = event.agenda;
      location = "Sickles High";
      startTime = "10:56";
      startTimeBack = "am";
      endTime = "11:31";
      endTimeBack = "am";
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewPage(event: event, userData: userData,)));
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
                  Text(event.date, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 25)),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(event.type == "clubDates" ? "Agenda" : "Description", 
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