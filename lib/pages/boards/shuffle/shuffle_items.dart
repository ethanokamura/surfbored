import 'package:flutter/material.dart';
import 'package:rando/shared/activity.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';
import 'package:rando/core/services/board_service.dart';
import 'package:rando/core/models/models.dart';

class ShuffleItemScreen extends StatefulWidget {
  final String boardID;
  const ShuffleItemScreen({super.key, required this.boardID});

  @override
  State<ShuffleItemScreen> createState() => _ShuffleItemScreenState();
}

class _ShuffleItemScreenState extends State<ShuffleItemScreen> {
  int index = 0;
  List<ItemData> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActivityList();
  }

  Future<void> loadActivityList() async {
    try {
      List<ItemData> itemList =
          await BoardService().getBoardItems(widget.boardID);
      itemList.shuffle();
      setState(() {
        items = itemList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.boardID),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : index < items.length
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ActivityWidget(item: items[index]),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: DefualtButton(
                                  inverted: true,
                                  text: "Select",
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: DefualtButton(
                                  inverted: false,
                                  text: "Skip",
                                  onTap: () {
                                    setState(() => index++);
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("No more items!"),
                        const SizedBox(height: 20),
                        DefualtButton(
                          text: "Return",
                          inverted: true,
                          onTap: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
