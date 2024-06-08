import 'dart:convert';

import 'package:employee_database/datatype/type.dart';
import 'package:employee_database/model/Note.dart';
import 'package:employee_database/model/color.dart';
import 'package:employee_database/model/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NotePage extends StatelessWidget {
  NoteOpenMode openType;
  NoteModel? note;
  NotePage({super.key, required this.openType, this.note});
  GlobalKey<FormState> _formKey = GlobalKey();
  var _controller = quill.QuillController.basic();
  final _titleController = TextEditingController();
  @override
  FocusNode f = FocusNode();
  Widget build(BuildContext context) {
    if (openType == NoteOpenMode.update) {
      _controller = quill.QuillController.basic()
        ..document = quill.Document.fromJson(jsonDecode(note!.content!));
      _titleController.text = note!.title!;
    }
    f.requestFocus();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: f,
                    // autovalidateMode: _validate.value,
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return "Please enter Title";
                      }
                    },
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: subTextColor.withOpacity(0.7),
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: quill.QuillEditor.basic(
                      configurations: quill.QuillEditorConfigurations(
                        customStyles: quill.DefaultStyles(
                            color: Colors.white,
                            paragraph: quill.DefaultListBlockStyle(
                                TextStyle(color: textColor),
                                quill.VerticalSpacing(0, 0),
                                quill.VerticalSpacing(0, 0),
                                null,
                                null)),
                        showCursor: true,
                        scrollPhysics: BouncingScrollPhysics(),
                        controller: _controller,
                        sharedConfigurations:
                            const quill.QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  // height: Get.height * 0.1,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: quill.QuillToolbar.simple(
                    configurations: quill.QuillSimpleToolbarConfigurations(
                      customButtons: [
                        quill.QuillToolbarCustomButtonOptions(
                            icon: Icon(
                          Icons.add_box,
                          color: textColor,
                        ))
                      ],
                      buttonOptions:
                          const quill.QuillSimpleToolbarButtonOptions(
                        // fontSize: quill.QuillToolbarFontSizeButtonOptions(
                        //     style: TextStyle(color: textColor)),

                        // fontFamily: quill.QuillToolbarFontFamilyButtonOptions(
                        //     style: TextStyle(color: textColor)),
                        base: quill.QuillToolbarBaseButtonOptions(
                          iconTheme: quill.QuillIconTheme(
                              // iconButtonUnselectedData:
                              // quill.IconButtonData(color: Colors.white),
                              // iconSelectedFillColor: Colors.red,
                              // iconUnselectedFillColor: Colors.yellow,
                              ),
                        ),
                      ),
                      showBackgroundColorButton: true,
                      controller: _controller,
                      multiRowsDisplay: false,
                      axis: Axis.horizontal,
                      color: Colors.transparent,
                      sharedConfigurations:
                          const quill.QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Container(
            height: Get.height * 0.07,
            margin: EdgeInsets.only(bottom: 50),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: accentColor.withOpacity(0.7),
                  blurRadius: 10,
                  offset: Offset(0, 5))
            ], color: accentColor, borderRadius: BorderRadius.circular(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (openType == NoteOpenMode.create) {
                        NoteModel n = NoteModel(
                            id: Uuid().v1(),
                            content: jsonEncode(
                                _controller.document.toDelta().toJson()),
                            title: _titleController.text.trim(),
                            time: DateTime.now());
                        DBHelper.addNote(n);
                        Get.back();
                      }
                      if (openType == NoteOpenMode.update) {
                        NoteModel n = NoteModel(
                            id: note!.id,
                            content: jsonEncode(
                                _controller.document.toDelta().toJson()),
                            title: _titleController.text.trim(),
                            time: DateTime.now());
                        DBHelper.updateNote(n);
                        Get.back();
                      }
                    } else {
                      // _validate.value = AutovalidateMode.always;
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
