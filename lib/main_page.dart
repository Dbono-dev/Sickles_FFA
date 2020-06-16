import 'package:flutter/material.dart';
import 'package:ffa_app/feed_page.dart';
import 'package:ffa_app/profile_page.dart';
import 'package:ffa_app/event_view.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            ProfilePage(),
            MainPageBody(),
            FeedPage()
          ]
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
            child: TabBar(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Padding(padding: EdgeInsets.all(12)),
          Text("Good Evening", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold)),
          Text("Test", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 45, fontWeight: FontWeight.bold),),
          Padding(padding: EdgeInsets.all(6)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewPage()));
            },
            child: Container(
              height: 400,
              width: 330,            
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
                        Text("Event Title", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35, fontWeight: FontWeight.bold),),
                        Text("Date", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35)),
                        Text("Description", style: TextStyle(color: Colors.white, fontSize: 30, decoration: TextDecoration.underline)),
                        Text("This is just where some text to show where the description would go", style: TextStyle(color: Colors.white, fontSize: 25), textAlign: TextAlign.center,),
                        Spacer(),
                        Text("Location | Time", style: TextStyle(color: Colors.white, fontSize: 25)),
                        Text("View Event", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 35, decoration: TextDecoration.underline, fontWeight: FontWeight.bold))
                      ]
                    ),
                  ),
                ),
              )
            ),
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
      ),
    );
  }
}