import 'package:flutter/material.dart';

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

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("All")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text("Favourites")
          ),
        ],
      ),
    );
  }

  void _addContact() {}
}
