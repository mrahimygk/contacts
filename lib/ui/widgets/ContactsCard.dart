import 'package:flutter/cupertino.dart';
import 'package:flutter_firstsourceio/data/model/Contact.dart';
import 'package:flutter/material.dart';

class ContactsCard extends StatelessWidget {
  final Contact contact;
  final Function(Contact contact) onRemove;
  final Function(Contact contact) onEdit;

  const ContactsCard({Key key, this.contact, this.onRemove, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onEdit(contact);
        }
        if (direction == DismissDirection.startToEnd) {
          onRemove(contact);
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
      key: Key(UniqueKey().toString()),
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
