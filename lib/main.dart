import 'package:flutter/material.dart';
import 'ui/main/ContactsHomePage.dart';
import 'ui/add/AddContactPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Manager',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: ContactsHomePage(title: 'Contact Manager Home Page'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext inContext) =>
            ContactsHomePage(title: 'Contact Manager Home Page'),
        '/new_contact': (BuildContext inContext) => AddContactPage(),
      },
    );
  }
}
