import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notebook/category.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/note_detail.dart';
import 'package:notebook/utils/dbHelper.dart';

import 'models/note.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DbHelper dbHelper;
  String categoryName;
  List<Note> noteList;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    noteList = List<Note>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add_circle_outline),
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("Add Category"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                onSaved: (value) {
                                  categoryName = value;
                                },
                                decoration: InputDecoration(
                                    labelText: "Category name",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              RaisedButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              RaisedButton(
                                child: Text("Save"),
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    dbHelper
                                        .insertCategory(Category(categoryName));
                                  }
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Category added"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                            alignment: MainAxisAlignment.spaceEvenly,
                          )
                        ],
                      );
                    });
              },
              mini: true,
              heroTag: "add category",
            ),
            FloatingActionButton(
              child: Icon(Icons.add_circle_outline),
              onPressed: () => goToDetail(),
              heroTag: "add note",
            ),
          ],
        ),
        appBar: AppBar(title: Text("Notes"), actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(Icons.category),
                title: Text("Categories"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage())),
              ))
            ];
          }),
        ]),
        body: Container(
          child: FutureBuilder(
            future: dbHelper.getNoteList(),
            builder: (context, AsyncSnapshot<List<Note>> snapshot) {
              if (snapshot.hasData) {
                noteList = snapshot.data;
                sleep(Duration(milliseconds: 500));
                return ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: buildPriority(noteList[index].note_priority),
                      title: Text(noteList[index].note_title),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Kategori: "),
                                  Text(noteList[index].category_name),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Created: "),
                                  Text(noteList[index].note_date)
                                ],
                              ),
                              Center(
                                child: Text(noteList[index].note_content),
                              )
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Text("Delete"),
                              onPressed: () {
                                deleteItem(noteList[index].note_id);
                              },
                            ),
                            FlatButton(
                              child: Text("Update"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoteDetail(
                                              selectedNote: noteList[index],
                                            )));
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              } else {
                return Center(child: Text("Loading..."));
              }
            },
          ),
        ));
  }

  goToDetail() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteDetail(),
        ));

    //below you can get your result and update the view with setState
    //changing the value if you want, i just wanted know if i have to
    //update, and if is true, reload state

    if (result != null && result) {
      setState(() {});
    }
  }

  Widget buildPriority(int note_priority) {
    switch (note_priority) {
      case 0:
        return CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent.shade100,
          child: Text("."),
        );
        break;

      case 1:
        return CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent.shade400,
          child: Text(".."),
        );
        break;

      case 2:
        return CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent.shade700,
          child: Text("..."),
        );
        break;
    }
  }

  void deleteItem(int note_id) {
    dbHelper.deleteNote(note_id).then((value) {
      if (value > 0) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Item deleted"),
          duration: Duration(seconds: 1),
        ));
      }
      setState(() {});
    });
  }
}
