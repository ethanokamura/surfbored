import 'package:flutter/material.dart';
import 'package:rando/pages/create/view/create_object.dart';

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
