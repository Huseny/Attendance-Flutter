// ignore_for_file: depend_on_referenced_packages

import 'package:facerecognition_flutter/person.dart';
// import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class DBHelper {
  Future<Database> createDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'person.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(name text, faceJpg blob, templates blob)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await createDB();

    final List<Map<String, dynamic>> maps = await db.query('person');

    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<Person> insertPerson(Person person) async {
    final db = await createDB();

    await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return person;
  }

  Future<void> deleteAllPerson() async {
    final db = await createDB();
    await db.delete('person');

    // Fluttertoast.showToast(
    //     msg: "All person deleted!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Future<void> deletePerson(String name) async {
    final db = await createDB();
    await db.delete('person', where: 'name=?', whereArgs: [name]);

    // Fluttertoast.showToast(
    //     msg: "Person removed!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }
}
