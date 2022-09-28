// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison, must_be_immutable, avoid_print, sized_box_for_whitespace
import 'package:chat_app/Helper/helper.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  Helper helperClass = Helper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // print(helperClass.imageFromGallery);
            Center(
              child: Container(
                height: 300,
                width: 200,
                color: Colors.grey.withOpacity(.2),
                child: helperClass.imageFromGallery == null
                    ? Center(
                        child: Text(
                        "Status Screen",
                        style: TextStyle(color: Colors.black),
                      ))
                    : Image.file(
                        helperClass.imageFromGallery!,
                        width: 200,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            ElevatedButton(
                onPressed: () async {
                  await helperClass.getSingleImageFromGallery();
                  setState(() {});
                },
                child: Text(
                  "Pick from Gallery",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
