import 'package:flutter/material.dart';

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

class ContactsListPage extends StatefulWidget {
  ContactsListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addContact() {}
}
