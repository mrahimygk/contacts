import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';
import 'package:flutter_firstsourceio/ui/widgets/ContactsCard.dart';

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
          final data = inStream.data;
          data.sort((a, b) => a.id.hashCode.compareTo(b.id.hashCode));
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(6.0),
            children: data
                .map((contact) => ContactsCard(
                      contact: contact,
                      onEdit: (c) {
                        print('editing $c');
                      },
                      onRemove: (c) {
                        cRepo.removeContact(c).then((f) {
                          cRepo.delete(c).then((cn) {
                            setState(() {});
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        'Contact ${c.firstName} ${c.lastName} removed'),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      child: Text('Undo'),
                                      onPressed: () {
                                        cRepo.insert(c);
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
      cRepo.getContactsFromNetwork().then((onValue) {
        setState(() {});
      });
    }
  }
}
