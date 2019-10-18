import 'package:flutter/cupertino.dart';
import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter/material.dart';

class ContactsCard extends StatelessWidget {
  final Contact contact;

  const ContactsCard({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          //TODO: edit
        }
        if (direction == DismissDirection.startToEnd) {
          //TODO: remove
        }
      },
      background: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Stack(children: <Widget>[
              Container(color: Colors.red),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Icon(
                    Icons.delete_forever,
                    size: 32.0,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ])),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(color: Colors.blue),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Icon(
                        Icons.edit,
                        size: 32.0,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      key: Key(contact.hashCode.toString()),
      child: Card(
        child: ListTile(
          title: Text('${contact.firstName} ${contact.lastName}'),
          leading: Icon(Icons.person),
          subtitle: Text(contact.email),
          trailing: Icon(Icons.star_border),
        ),
      ),
    );
  }
}
