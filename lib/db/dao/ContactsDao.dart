import 'package:flutter_firstsourceio/data/model/Contact.dart';
import 'package:flutter_firstsourceio/db/dao/Dao.dart';

class ContactsDao implements Dao<Contact> {
  @override
  String get createTableQuery => 'create table $contactsTable (   '
      '$contactsColumnId text primary key,  '
      '$contactsColumnFirstName text,  '
      '$contactsColumnLastName text, '
      '$contactsColumnEmail text, '
      '$contactsColumnGender text, '
      '$contactsColumnDateOfBirth text, '
      '$contactsColumnPhoneNo text '
      ')';

  @override
  Map<String, dynamic> toMap(Contact object) {
    return <String, dynamic>{
      contactsColumnId: object.id,
      contactsColumnFirstName: object.firstName,
      contactsColumnLastName: object.lastName,
      contactsColumnEmail: object.email,
      contactsColumnGender: object.gender,
      contactsColumnDateOfBirth: object.dateOfBirth,
      contactsColumnPhoneNo: object.phoneNo,
    };
  }

  @override
  List<Contact> fromList(List<Map<String, dynamic>> query) {
    List<Contact> contacts = List<Contact>();
    for (Map map in query) {
      contacts.add(fromMap(map));
    }

    return contacts;
  }

  @override
  Contact fromMap(Map<String, dynamic> query) {
    Contact contact = Contact(
      id: query[contactsColumnId],
      firstName: query[contactsColumnFirstName],
      lastName: query[contactsColumnLastName],
      email: query[contactsColumnEmail],
      gender: query[contactsColumnGender],
      dateOfBirth: query[contactsColumnDateOfBirth],
      phoneNo: query[contactsColumnPhoneNo],
    );

    return contact;
  }
}

const contactsTable = 'contacts';
const contactsColumnId = '_id';
const contactsColumnFirstName = 'firstName';
const contactsColumnLastName = 'lastName';
const contactsColumnEmail = 'email';
const contactsColumnGender = 'gender';
const contactsColumnDateOfBirth = 'dateOfBirth';
const contactsColumnPhoneNo = 'phoneNo';
