class Note{
  int note_id;
  int category_id;
  String category_name;
  String note_title;
  String note_content;
  String note_date;
  int note_priority;

  Note(this.category_id, this.note_title, this.note_content,
      this.note_date, this.note_priority);

  Note.withId(this.note_id, this.category_id, this.note_title,
      this.note_content, this.note_date, this.note_priority);

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map["note_id"] = this.note_id;
    map["category_id"] = this.category_id;
    map["note_title"] = this.note_title;
    map["note_content"] = this.note_content;
    map["note_date"] = this.note_date;
    map["note_priority"] = this.note_priority;
    return map;
  }

  Note.fromMap(Map<String,dynamic> map){
    this.note_id = map["note_id"];
    this.category_id = map["category_id"];
    this.category_name = map["category_name"];
    this.note_title = map["note_title"];
    this.note_content = map["note_content"];
    this.note_date = map["note_date"];
    this.note_priority = map["note_priority"];
  }
}