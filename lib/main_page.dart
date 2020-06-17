import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffa_app/database.dart';
import 'package:ffa_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/feed_page.dart';
import 'package:ffa_app/profile_page.dart';
import 'package:ffa_app/event_view.dart';
import 'package:ffa_app/user.dart';
import 'package:provider/provider.dart';

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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            ProfilePage(),
            MainPageBody(),
            FeedPage()
          ]
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
            child: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.person, size: 27,),
                  text: "Profile",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.home, size: 27,),
                  text: "Home",
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  icon: Icon(Icons.dehaze, size: 27,),
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

class MainPageBody extends StatelessWidget {

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("events").getDocuments();
    
    return qn.documents;
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
                Padding(padding: EdgeInsets.all(12)),
                Text(timeOfDay, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold)),
                Text(userData.firstName, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.all(6)),
                FutureBuilder(
                  future: getPosts(),
                  builder: (_, index) {
                    if(index.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    else {
                      return Container(
                        color: Colors.transparent,
                        height: 400,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ListView.builder(
                          itemCount: index.data.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (_, i) {
                            return eventCard(context, index.data[i], userData);
                          },
                        ),
                      );
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Icon(Icons.arrow_back, size: 50,),
                    Icon(Icons.arrow_forward, size: 50,),
                  ]
                )
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
    String startTime = snapshot.data['start time'].toString();
    String endTime = snapshot.data['end time'].toString();

    int startTimeTest = int.parse(snapshot.data['start time'].toString().substring(0, 2));

    if(startTimeTest >= 12) {
      startTimeTest = startTimeTest - 12;
      startTimeBack = " pm";
      startTime = startTimeTest.toString() + startTime.substring(2);
    }
    else {
      startTimeBack = " am";
    }

    int endTimeTest = int.parse(snapshot.data['end time'].toString().substring(0, 2));

    if(endTimeTest >= 12) {
      endTimeTest = endTimeTest - 12;
      endTimeBack = " pm";
      endTime = endTimeTest.toString() + endTime.substring(2);
    }
    else {
      endTimeBack = " am";
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewPage(snapshot: snapshot, userData: userData,)));
      },
      child: Container(
        height: 400,
        width: 330,   
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
                  Text(snapshot.data['title'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35, fontWeight: FontWeight.bold),),
                  Text(snapshot.data['date'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 27.5)),
                  Text("Description", style: TextStyle(color: Colors.white, fontSize: 30, decoration: TextDecoration.underline)),
                  Text(snapshot.data['description'], style: TextStyle(color: Colors.white, fontSize: 25), textAlign: TextAlign.center,),
                  Spacer(),
                  Text(snapshot.data['location'], style: TextStyle(color: Colors.white, fontSize: 25)),
                  Text(startTime + startTimeBack + " - " + endTime + endTimeBack, style: TextStyle(color: Colors.white, fontSize: 25)),
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