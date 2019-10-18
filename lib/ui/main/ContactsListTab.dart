import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';

class ContactsListTab extends StatefulWidget {
  _ContactsListTabState createState() => _ContactsListTabState();
}

class _ContactsListTabState extends State<ContactsListTab> {

  final cRepo = ContactsRepositoryImpl(DatabaseProvider.get);

  @override
  void initState() {
    cRepo.getContactsFromNetwork();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ContactsListTab'),
    );
  }
}
