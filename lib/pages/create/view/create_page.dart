import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/create/view/create_object.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({required this.type, super.key});

  static MaterialPage<void> page({required String type}) {
    return MaterialPage<void>(
      child: CreatePage(type: type),
    );
  }

  final String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: type == 'items'
            ? const Text('Create An Activity!')
            : const Text('Create A Board!'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: CreateObject(type: type),
        ),
      ),
    );
  }
}
