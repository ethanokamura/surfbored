import 'package:flutter/material.dart';

class SelectCreateScreen extends StatelessWidget {
  const SelectCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 20),
          child: Column(
            children: [
              Text(
                "Create Something!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/create-activity'),
                        child: const Text("create activity"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/create-board'),
                        child: const Text("create board"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
