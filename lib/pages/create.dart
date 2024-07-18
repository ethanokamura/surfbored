import 'package:flutter/material.dart';
import 'package:rando/components/create/create_object.dart';
// import 'package:rando/components/tab_bar/tab.dart';
// import 'package:rando/components/tab_bar/tab_bar.dart';

class CreateScreen extends StatelessWidget {
  final String type;
  const CreateScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: type == 'items'
              ? const Text("Create An Activity!")
              : const Text("Create A Board!"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CreateObjectWidget(type: type),
          ),
        ),
      ),
    );
  }
}
