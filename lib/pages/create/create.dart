import 'package:flutter/material.dart';
import 'package:rando/components/create/create_object.dart';
import 'package:rando/components/tab_bar/tab.dart';
import 'package:rando/components/tab_bar/tab_bar.dart';

class CreateObjectScreen extends StatelessWidget {
  const CreateObjectScreen({super.key});

  final String type = 'items';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Something!"),
        ),
        body: SafeArea(
          child: buildCreateScreen(context),
        ),
      ),
    );
  }
}

Widget buildCreateScreen(BuildContext context) {
  return const CustomScrollView(
    slivers: [
      SliverSafeArea(
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTabBarWidget(
                  tabs: [
                    CustomTabWidget(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Activity',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    CustomTabWidget(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Board',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      SliverFillRemaining(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TabBarView(
            children: [
              CreateObjectWidget(type: "items"),
              CreateObjectWidget(type: "boards"),
            ],
          ),
        ),
      ),
    ],
  );
}
