import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';
import 'package:flutter_firstsourceio/ui/widgets/ContactsCard.dart';

class ContactsListTab extends StatefulWidget {
  _ContactsListTabState createState() => _ContactsListTabState();
}

class _ContactsListTabState extends State<ContactsListTab> {
  final contactsRepo = ContactsRepositoryImpl(DatabaseProvider.get);
  ScrollController scrollController;

  @override
  void initState() {
    contactsRepo.getContactsFromNetwork();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
        future: contactsRepo.getContactsFromDb(),
        builder: (context, inStream) {
          if (!inStream.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = inStream.data;
          data.sort((a, b) => a.firstName.compareTo(b.firstName));
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(6.0),
            children: data
                .map((contact) => ContactsCard(
                      contact: contact,
                      onEdit: (c) {
                        print('editing $c');
                      },
                      onRemove: (theRemovingContact) {
                        contactsRepo
                            .removeContactApi(theRemovingContact)
                            .then((f) {
                          contactsRepo.delete(theRemovingContact).then((cn) {
                            setState(() {});
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        'Contact ${theRemovingContact.firstName} ${theRemovingContact.lastName} removed'),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      child: Text('Undo'),
                                      onPressed: () {
                                        contactsRepo
                                            .insert(theRemovingContact)
                                            .then((g) {
                                          contactsRepo
                                              .insertApi(theRemovingContact);
                                        });
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          });
                        });
                      },
                    ))
                .toList(),
          );
        });
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print('reached the end: asking new items');
      contactsRepo.getContactsFromNetwork().then((onValue) {
        setState(() {});
      });
    }
  }
}
