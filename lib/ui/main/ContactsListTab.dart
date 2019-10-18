import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/data/model/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';
import 'package:flutter_firstsourceio/ui/widgets/ContactsCard.dart';

class ContactsListTab extends StatefulWidget {
  _ContactsListTabState createState() => _ContactsListTabState();
}

class _ContactsListTabState extends State<ContactsListTab> {
  final contactsRepo = ContactsRepositoryImpl(DatabaseProvider.get);
  ScrollController scrollController;
  String filter;

  final TextEditingController contactsSearchController =
      TextEditingController();

  @override
  void initState() {
    contactsRepo.getContactsFromNetwork();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    contactsSearchController.addListener(() {
      setState(() {
        filter = contactsSearchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    contactsSearchController.dispose();
    super.dispose();
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
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: TextField(
                  controller: contactsSearchController,
                  onChanged: (value) {},
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Type to Search...',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(6.0),
                  children: data.map((contact) {
                    final card = ContactsCard(
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
                    );
                    return filter == null || filter == ""
                        ? card
                        : contact.firstName
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                contact.lastName
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                contact.email
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                contact.phoneNo
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                            ? card
                            : Container();
                  }).toList(),
                ),
              ),
            ],
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

class ContactSearch extends SearchDelegate<Contact> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return null;
  }
}
