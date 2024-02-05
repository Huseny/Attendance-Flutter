import 'package:facerecognition_flutter/utils/db.dart';
import 'package:flutter/material.dart';
import '../../person.dart';

// ignore: must_be_immutable
class PersonView extends StatefulWidget {
  final List<Person> personList;

  const PersonView({super.key, required this.personList});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  final DBHelper db = DBHelper();

  deletePerson(String name) async {
    await db.deletePerson(name);
    setState(() {
      widget.personList.removeWhere((element) => element.name == name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.white,
            ),
        itemCount: widget.personList.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
              height: 75,
              child: Card(
                  child: Row(
                children: [
                  Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Image.memory(
                    widget.personList[index].faceJpg,
                    width: 56,
                    height: 56,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(widget.personList[index].name),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        deletePerson(widget.personList[index].name),
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              )));
        });
  }
}
