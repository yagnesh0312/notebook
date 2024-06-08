import 'dart:async';

import 'package:employee_database/model/Note.dart';
import 'package:employee_database/model/dbHelper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DBController extends GetxController {
  RxList notes = [].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    background();
    super.onInit();
  }

  getData() async {
    notes.value = await DBHelper.getNote();
    update();
  }

  oninsert(NoteModel n) {
    DBHelper.addNote(n);
    update();
  }

  ondelete(NoteModel n) {
    DBHelper.deleteNote(n);
    update();
  }

  onUpdate(NoteModel n) {
    DBHelper.updateNote(n);
    update();
  }
  background(){
    int prev = notes.length;
    Timer.periodic(Duration(milliseconds: 500), (timer) async{
      DBHelper.getNote().then((value) {
        if(value.length != prev){
          getData();
        }
      });
    });
  }
}
