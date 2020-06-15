import 'package:ffa_app/auth_service.dart';
import 'package:ffa_app/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:ffa_app/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'FFA App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF004C97),
          accentColor: const Color(0xFFFFCD00),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}