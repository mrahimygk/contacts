import 'package:flutter_firstsourceio/data/Contact.dart';
import 'package:flutter_firstsourceio/db/dao/ContactsDao.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepository.dart';
import 'package:dio/dio.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final dao = ContactsDao();

  final contactsPerPage= 10;
  int contactsPage = 1;

  final dio = Dio(
    BaseOptions(
      method: "GET",
      headers: {
        "x-api-key": "i think there is no api key provided by firstsource.io"
      },
    ),
  );

  @override
  DatabaseProvider databaseProvider;

  ContactsRepositoryImpl(this.databaseProvider);

  @override
  Future<Contact> delete(Contact data) async {
    final db = await databaseProvider.db();

    await db.delete(contactsTable,
        where: '$contactsColumnId = ?', whereArgs: [data.id]);
    return data;
  }

  @override
  Future<List<Contact>> getContactsFromDb() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(
      contactsTable,
      columns: [
        contactsColumnId,
        contactsColumnFirstName,
        contactsColumnLastName,
        contactsColumnEmail,
        contactsColumnGender,
        contactsColumnDateOfBirth,
        contactsColumnPhoneNo,
      ],
    );
    if (maps.length > 0) {
      return dao.fromList(maps);
    }
    return null;
  }

  @override
  Future<List<Contact>> getContactsFromNetwork() async {
    final response = await dio.get(CONTACTS_URL,
        queryParameters: {"page": contactsPage++, "row": contactsPerPage});
    print(response);
    var data = List<Contact>();
    for (var value in response.data['data']) {
      print(value);
      data.add(Contact.fromMap(value));
    }

    return null;
  }

  @override
  Future<Contact> insert(Contact data) async {
    final db = await databaseProvider.db();
    data.id = await db.insert(contactsTable, data.toMap());
    return data;
  }

  @override
  Future<Contact> update(Contact data) async {
    final db = await databaseProvider.db();
    await db.update(contactsTable, data.toMap(),
        where: '$contactsColumnId = ?', whereArgs: [data.id]);
    return data;
  }
}

const CONTACTS_URL = "https://mock-rest-api-server.herokuapp.com/api/v1/user/";