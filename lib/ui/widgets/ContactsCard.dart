import 'package:flutter/cupertino.dart';
import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter/material.dart';

class ContactsCard extends StatelessWidget {
  final Contact contact;

  const ContactsCard({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(contact.firstName),
      ),
    );
  }
}
