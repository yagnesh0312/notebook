import 'dart:async';

import 'package:notebook/model/Note.dart';
import 'package:notebook/model/dbHelper.dart';
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
    getData();
    update();
  }

  ondelete(NoteModel n) {
    DBHelper.deleteNote(n);
    getData();
    update();
  }

  onUpdate(NoteModel n) {
    DBHelper.updateNote(n);
    getData();
    update();
  }

  background() {
    int prev = notes.length;

    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      DBHelper.getNote().then((value) {
        if (value.length != prev) {
          prev = value.length;
          getData();
          print("DB Update");
        }
      });
    });
  }
}
