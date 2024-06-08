import 'package:employee_database/datatype/type.dart';

class NoteModel {
  String? id;
  String? title;
  String? content;
  DateTime? time;
  NoteModel({this.id, this.title, this.content,this.time});
  MyMap toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "time": time!.millisecondsSinceEpoch,
    };
  }
  NoteModel.fromMap(MyMap map){
    id = map["id"];
    title = map["title"];
    time = DateTime.fromMillisecondsSinceEpoch(map["time"]);
    content = map["content"];
  }
}
