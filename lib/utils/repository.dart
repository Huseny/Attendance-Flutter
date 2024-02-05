// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:facerecognition_flutter/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomRepository {
  final String _url = 'http://192.168.234.80:8000';
  DBHelper dbHelper = DBHelper();

  Future<Map<String, dynamic>> getLabel(Uint8List image) async {
    String path = await _saveImage(image);

    final request = http.MultipartRequest('POST', Uri.parse("$_url/recognize/"))
      ..files.add(await http.MultipartFile.fromPath('image', path));
    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = (await http.Response.fromStream(response)).body;
        final jsonResponse = json.decode(responseBody);
        debugPrint('Response: $jsonResponse');
        final imagePath = await _saveImage(image);

        return {
          "id": jsonResponse["id"],
          "image": imagePath,
          "label": jsonResponse["label"],
          "distance": jsonResponse["distance"],
        };
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        throw HttpException(response.reasonPhrase ?? "Error");
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  Future<String> _saveImage(Uint8List image) async {
    String path =
        join(await getDatabasesPath(), 'images', "${DateTime.now()}.jpg");
    File fileDef = File(path);
    await fileDef.create(recursive: true);
    File img = await fileDef.writeAsBytes(image);
    return img.path;
  }
}
