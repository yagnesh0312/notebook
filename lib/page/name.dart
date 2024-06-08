import 'package:notebook/model/color.dart';
import 'package:notebook/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePage extends StatelessWidget {
  NamePage({super.key});
  final _controller = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey();
  onGo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("name", _controller.text);
    Get.offAll(HomePage());
  }

  onInit() async {
    SharedPreferences sb = await SharedPreferences.getInstance();
    var st = sb.getString("name");
    if (st != null) {
      Get.offAll(HomePage());
    }
  }

  final content =
      "Welcome to our note-taking app, where your thoughts find a home. Effortlessly capture ideas, to-dos, and inspirations with simplicity and style. Streamline your productivity and creativity in one seamless interface.";
  final name = "NoteBook";

  var _validate = AutovalidateMode.disabled.obs;
  @override
  Widget build(BuildContext context) {
    onInit();
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Expanded(child: Image.asset("assets/img.png")),
            // SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: subBackgroundColor,
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 30),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 60),
                  ),
                  Text(
                    content,
                    style: TextStyle(color: subTextColor, fontSize: 10),
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _form,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      // decoration: BoxDecoration(
                      //     color: subBackgroundColor,
                      //     borderRadius: BorderRadius.only(
                      //       bottomRight: Radius.circular(100),
                      //       topLeft: Radius.circular(100),
                      //       topRight: Radius.circular(100),
                      //     )),
                      child: Obx(() => TextFormField(
                            autovalidateMode: _validate.value,
                            validator: (v) {
                              if (!RegExp(r'^[A-Za-z]*$').hasMatch(v!) ||
                                  v.trim().isEmpty) {
                                return "Please enter[A- Valid name";
                              }
                            },
                            style: TextStyle(
                                color: textColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            controller: _controller,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              // border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: subTextColor.withOpacity(0.4),
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      _validate.value = AutovalidateMode.always;
                      if (_form.currentState!.validate()) {
                        onGo();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: accentColor.withOpacity(0.3),
                                blurRadius: 10)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Let's Started",
                            style: TextStyle(
                                color: subBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
