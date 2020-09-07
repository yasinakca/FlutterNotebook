import 'package:flutter/material.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/utils/dbHelper.dart';

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
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
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
                          onSaved: (value){
                            categoryName = value;
                          },
                          decoration: InputDecoration(
                            labelText:  "Category name",
                            border: OutlineInputBorder()
                          ),
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
                          onPressed: (){
                            if(formKey.currentState.validate()){
                              formKey.currentState.save();
                              dbHelper.insertCategory(Category(categoryName));
                            }
                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Category added"),duration: Duration(seconds: 1),));
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
            onPressed: () => null,
            heroTag: "add note",
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: Container(),
    );
  }
}
