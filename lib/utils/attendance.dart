import 'package:facerecognition_flutter/person.dart';
import 'package:facerecognition_flutter/utils/db.dart';
import 'package:facerecognition_flutter/utils/repository.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class Attendance {
  final DBHelper _db = DBHelper();
  final CustomRepository _repository = CustomRepository();
  final _facesdkPlugin = FacesdkPlugin();

  Future<List<Person>> fromImage() async {
    try {
      final List<Person> attendees = [];
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return [];

      var rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
      for (var face in faces) {
        final Map<String, dynamic> faceData =
            await _repository.getLabel(face['faceJpg']);
        Person person = Person(
            name: faceData['label'],
            faceJpg: face['faceJpg'],
            templates: face['templates']);
        debugPrint("Person: ${person.name}");
        _db.insertPerson(person);
        attendees.add(person);
      }

      if (faces.length == 0) {
        // Fluttertoast.showToast(
        //     msg: "No face detected!",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      } else {
        // Fluttertoast.showToast(
        //     msg:
        //         "Attendance Taken Successfully! Below is the list of students who have taken attendance.",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        debugPrint("Attendees: $attendees");
      }
      return attendees;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Person>> fromCamera() async {
    debugPrint("From Camera");
    try {
      final List<Person> attendees = [];
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return [];

      var rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
      for (var face in faces) {
        debugPrint("Person: ${face['faceJpg']}");
        final Map<String, dynamic> faceData =
            await _repository.getLabel(face['faceJpg']);
        debugPrint("Face Data: $faceData");
        Person person = Person(
            name: faceData['label'],
            faceJpg: face['faceJpg'],
            templates: face['templates']);
        _db.insertPerson(person);
        attendees.add(person);
      }

      if (faces.length == 0) {
        // Fluttertoast.showToast(
        //     msg: "No face detected!",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      } else {
        // Fluttertoast.showToast(
        //     msg:
        //         "Attendance Taken Successfully! Below is the list of students who have taken attendance.",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        debugPrint("Attendees: $attendees");
      }
      return attendees;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<Person>> fromVideo() async* {
    yield [];
  }
}
