import 'package:flutter/material.dart';
import 'package:notebook/models/category.dart';
import 'package:notebook/utils/dbHelper.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  DbHelper dbHelper;
  List<Category> categoryList;
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    deleteCategory(categoryList[index].category_id);
                  },
                  title: Text(categoryList[index].category_name),
                  trailing: Icon(Icons.delete),
                ),
              );
            }),
      ),
    );
  }

  void updateCategoryList() {
    dbHelper.getCategoryList().then((value) {
      if(value.length != 0){
        setState(() {
          categoryList = value;
        });
      }
    });
  }

  void deleteCategory(int category_id) {
    dbHelper.deleteCategory(category_id).then((value) {
      if (value != 0) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Category deleted"),
          duration: Duration(seconds: 1),
        ));
        setState(() {
          updateCategoryList();
        });
      }
    });
  }
}
