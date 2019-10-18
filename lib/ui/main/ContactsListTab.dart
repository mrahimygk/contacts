import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';

class ContactsListTab extends StatefulWidget {
  _ContactsListTabState createState() => _ContactsListTabState();
}

class _ContactsListTabState extends State<ContactsListTab> {
  final cRepo = ContactsRepositoryImpl(DatabaseProvider.get);
  ScrollController scrollController;

  @override
  void initState() {
    cRepo.getContactsFromNetwork();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
        future: cRepo.getContactsFromDb(),
        builder: (context, inStream) {
          if (!inStream.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(6.0),
            children: inStream.data
                .map((contact) => Dismissible(
                      key: Key(contact.hashCode.toString()),
                      child: Card(
                        child: ListTile(
                          title: Text(contact.firstName),
                        ),
                      ),
                    ))
                .toList(),
          );
        });
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print('reached the end: asking new items');
      cRepo.getContactsFromNetwork().then((onValue) {
        setState(() {});
      });
    }
  }
}
