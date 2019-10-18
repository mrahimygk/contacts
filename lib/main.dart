import 'package:flutter/material.dart';
import 'pages/ContactsListPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Manager',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: ContactsListPage(title: 'Contact Manager Home Page'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext inContext) =>
            ContactsListPage(title: 'Contact Manager Home Page')
      },
    );
  }
}
