import 'package:notebook/component/notetile.dart';
import 'package:notebook/datatype/type.dart';
import 'package:notebook/model/Controller.dart';
import 'package:notebook/model/Note.dart';
import 'package:notebook/model/color.dart';
import 'package:notebook/page/name.dart';
import 'package:notebook/page/newNote.dart';
import 'package:flutter/gestures.dart';
// import 'package:notebook/page/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  var name = "My".obs;
  onInit() async {
    SharedPreferences sb = await SharedPreferences.getInstance();
    var st = sb.getString("name");
    if (st == null) {
      Get.offAll(NamePage());
    } else {
      name.value = "$st's";
    }
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Obx(() => Text(
              "$name Notes",
              style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences sb = await SharedPreferences.getInstance();
                sb.remove("name");
                Get.offAll(NamePage());
              },
              icon: Icon(Icons.edit))
        ],
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        // centerTitle: true,
      ),
      body: Container(
        child: GetX<DBController>(
            init: DBController(),
            builder: (controller) {
              List notes = controller.notes.value;
              return MasonryGridView.count(
                crossAxisCount: 2,
                
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(10),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  NoteModel note = notes[index] as NoteModel;
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    // splashColor: accentColor,
                    highlightColor: accentColor,
                    onTap: () {
                      Get.to(
                        NotePage(
                          openType: NoteOpenMode.update,
                          note: note,
                        ),
                        transition: tran,
                        duration: dur,
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: subBackgroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: NoteTile(
                        n: note,
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(
            NotePage(
              openType: NoteOpenMode.create,
            ),
            transition: tran,
            duration: dur,
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: accentColor, borderRadius: BorderRadius.circular(100)),
          child: Icon(
            Icons.add_rounded,
            size: 40,
            color: backgroundColor,
          ),
        ),
      ),
    );
  }
}
