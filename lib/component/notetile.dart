import 'dart:convert';

import 'package:notebook/model/Note.dart';
import 'package:notebook/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final NoteModel n;
  const NoteTile({super.key, required this.n});

  @override
  Widget build(BuildContext context) {
    String jsonData = '[{"insert": "Yahud8dvdidvd"}]';
    List<dynamic> parsedData = jsonDecode(n.content!);
    
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            n.title!, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: textColor, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.2),
            child: Text(
              Document.fromJson(parsedData).toPlainText(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: subTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height:5),
          Text(
            DateFormat("d MMM").format(n.time!),
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
