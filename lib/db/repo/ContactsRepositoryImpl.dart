import 'package:flutter_firstsourceio/data/model/Contact.dart';
import 'package:flutter_firstsourceio/db/dao/ContactsDao.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepository.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final dao = ContactsDao();

  final contactsPerPage = 10;
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
    var data = List<Contact>();
    for (var value in response.data['data']) {
      final c = Contact.fromMap(value);
      insert(c);
      data.add(c);
    }

    return data;
  }

  @override
  Future<Contact> insert(Contact data) async {
    final db = await databaseProvider.db();
    data.id = await db.insert(contactsTable, dao.toMap(data),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return data;
  }

  @override
  Future<Contact> update(Contact data) async {
    final db = await databaseProvider.db();
    await db.update(contactsTable, dao.toMap(data),
        where: '$contactsColumnId = ?', whereArgs: [data.id]);
    return data;
  }

  Future removeContactApi(Contact data) async {
    return await dio.delete("$CONTACTS_URL/${data.id.toString()}");
  }

  Future insertApi(Contact data) async {
    final inserted =  await dio.post(CONTACTS_URL, data: data.toMap());
    return inserted.data;
  }
}

const CONTACTS_URL = "https://mock-rest-api-server.herokuapp.com/api/v1/user";
