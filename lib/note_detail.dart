import 'package:flutter/material.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/utils/dbHelper.dart';

import 'main.dart';

class NoteDetail extends StatefulWidget {
  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  int categoryId = 1;
  String noteTitle;
  String noteContent;
  int priorityId = 0;

  var formKey = GlobalKey<FormState>();
  DbHelper dbHelper;
  List<Category> categoryList;
  List<String> priorityList = ["Low", "Medium", "High"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    categoryList = List<Category>();
    dbHelper.getCategory().then((value) {
      for (Map map in value) {
        categoryList.add(Category.fromMap(map));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Detail"),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Category"),
                      DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<int>(
                              items: buildCategoryItems(),
                              value: categoryId,
                              onChanged: (value) {
                                setState(() {
                                  categoryId = value;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          noteTitle = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Title", border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          noteContent = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Content", border: OutlineInputBorder()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Priority"),
                      DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                              value: priorityId,
                              items: buildPriorityItems(),
                              onChanged: (value) {
                                setState(() {
                                  priorityId = value;
                                });
                              }))
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context)),
                      RaisedButton(
                          child: Text("Save"),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              var today = DateTime.now();
                              var noteDate = dbHelper.dateFormat(today);
                              dbHelper.insertNote(Note(categoryId, noteTitle,
                                  noteContent, noteDate, priorityId));
                                Navigator.pop(context,true);
                            }
                          })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> buildCategoryItems() {
    return categoryList.map((value) {
      return DropdownMenuItem<int>(
        child: Text(value.category_name),
        value: value.category_id,
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> buildPriorityItems() {
    return priorityList.map((value) {
      return DropdownMenuItem<int>(
        child: Text(value),
        value: priorityList.indexOf(value),
      );
    }).toList();
  }
}
