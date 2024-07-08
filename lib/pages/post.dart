import 'package:flutter/material.dart';
import 'package:rando/components/create_tags.dart';
import 'package:rando/components/image.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const ImageWidget(),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'title',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'description',
                ),
              ),
              const SizedBox(height: 20),
              const CreateTagsWidget(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
