// ignore_for_file: unused_import, unused_local_variable, unnecessary_null_comparison
import 'dart:io';

import 'package:chat_app/Helper/helper.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Helper helper = Helper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: helper.multipleImagesFromGallery!.isEmpty
                ? Center(
                    child: Container(
                      height: 200,
                      width: 360,
                      color: Colors.blue,
                      child: const Center(
                        child: Text("Got Nothing",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: helper.multipleImagesFromGallery!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // final imagesList = helper.multipleImagesFromGallery![index];
                      return Image.file(
                          File(helper.multipleImagesFromGallery![index].path),
                          fit: BoxFit.cover);
                    }),
          ),
          ElevatedButton(
              onPressed: () async {
                await helper.getMultipleImages();
                setState(() {});
              },
              child: const Text(
                "Get Images",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
