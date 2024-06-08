import 'package:employee_database/datatype/type.dart';
import 'package:employee_database/model/Note.dart';
import 'package:employee_database/model/color.dart';
import 'package:employee_database/model/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NotePage extends StatelessWidget {
  NoteOpenMode openType;
  NoteModel? note;
  NotePage({super.key, required this.openType, this.note});
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode f = FocusNode();
  @override
  Widget build(BuildContext context) {

    f.requestFocus();
    final _titleController =
        TextEditingController(text: note != null ? note!.title : "");
    final _contentController =
        TextEditingController(text: note != null ? note!.content : "");
    var _validate = AutovalidateMode.disabled.obs;
    return Form(
      key: _formKey,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
            border: Border.all(color: accentColor)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => TextFormField(
                    focusNode: f,
                    autovalidateMode: _validate.value,
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return "Please enter Title";
                      }
                    },
                    controller: _titleController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: subTextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Text(
                  DateFormat("MMM dd,yyyy at hh:mm a").format(DateTime.now()),
                  style: TextStyle(
                      color: subTextColor.withOpacity(1), fontSize: 10),
                ),
                Expanded(
                  child: Obx(
                    () => TextFormField(
                      autovalidateMode: _validate.value,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _contentController,
                      maxLines: null,
                      validator: (v) {
                        if (v!.trim().isEmpty) {
                          return "Please enter content";
                        }
                      },
                      style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your Content here..",
                          hintStyle: TextStyle(
                              color: subTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            height: 60,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: accentColor, borderRadius: BorderRadius.circular(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (openType == NoteOpenMode.create) {
                        NoteModel n = NoteModel(
                            id: Uuid().v1(),
                            content: _contentController.text.trim(),
                            title: _titleController.text.trim(),
                            time: DateTime.now());
                        DBHelper.addNote(n);
                        Get.back();
                      }
                      if (openType == NoteOpenMode.update) {
                        NoteModel n = NoteModel(
                            id: note!.id,
                            content: _contentController.text.trim(),
                            title: _titleController.text.trim(),
                            time: DateTime.now());
                        DBHelper.updateNote(n);
                        Get.back();
                      }
                    } else {
                      _validate.value = AutovalidateMode.always;
                    }
                    // Get.to(NotePage(),
                    //     transition: Transition.downToUp,
                    //     duration: Duration(milliseconds: 500));
                  },
                  child: Icon(
                    Icons.save_rounded,
                    size: 30,
                    color: backgroundColor,
                  ),
                ),
                openType == NoteOpenMode.update
                    ? VerticalDivider(
                        // height: 4,
                        color: Colors.black.withOpacity(0.5),
                      )
                    : SizedBox(),
                openType == NoteOpenMode.update
                    ? GestureDetector(
                        child: Icon(
                          Icons.delete,
                          size: 30,
                          color: backgroundColor,
                        ),
                        onTap: () {
                          DBHelper.deleteNote(note!);
                          Get.back();
                        },
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
