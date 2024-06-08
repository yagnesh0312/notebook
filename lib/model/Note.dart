import 'package:notebook/datatype/type.dart';

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
    // print(map["time"]);
    time = DateTime.fromMillisecondsSinceEpoch(map['time']);
    content = map["content"];
  }
}
