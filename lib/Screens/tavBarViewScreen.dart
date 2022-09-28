// ignore_for_file: file_names
import 'package:flutter/material.dart';

class TabBarViewWidget extends StatelessWidget {
  final String title;
  const TabBarViewWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
