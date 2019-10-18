import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
abstract class ContactsRepository {
  DatabaseProvider databaseProvider;

  Future<Contact> insert(Contact data);

  Future<Contact> update(Contact data);

  Future<Contact> delete(Contact data);

  Future<List<Contact>> getContactsFromDb();

  Future<List<Contact>> getContactsFromNetwork();
}