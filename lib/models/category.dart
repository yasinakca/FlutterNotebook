class Category{
  int category_id;
  String category_name;

  Category(this.category_name);
  Category.withId(this.category_id, this.category_name);

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map["category_id"] = this.category_id;
    map["category_name"] = this.category_name;
    return map;
  }

  Category.fromMap(Map<String,dynamic> map){
    this.category_id = map["category_id"];
    this.category_name = map["category_name"];
  }
}