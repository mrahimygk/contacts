import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/ui/main/ContactsFavTab.dart';
import 'package:flutter_firstsourceio/ui/main/ContactsListTab.dart';

class ContactsHomePage extends StatefulWidget {
  ContactsHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ContactsHomePageState createState() => _ContactsHomePageState();
}

class _ContactsHomePageState extends State<ContactsHomePage> {
  int currentTabIndex = 0;

  List<Widget> tabs = [ContactsListTab(), ContactsFavTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: tabs[currentTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("All")),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text("Favourites")),
        ],
        onTap: onTapped,
        currentIndex: currentTabIndex,
      ),
    );
  }

  void _addContact() {
    Navigator.of(context).pushNamed('/new_contact', arguments: null);
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
}
