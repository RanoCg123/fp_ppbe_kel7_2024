import 'package:flutter/material.dart';

import '../services/post_service.dart';

class DropdownTopicWidget extends StatefulWidget {
  final Function(String) changeTopic;
  final String defaultTopic;

  const DropdownTopicWidget({super.key, required this.changeTopic, required this.defaultTopic});

  @override
  State<DropdownTopicWidget> createState() => _DropdownTopicWidgetState();
}

class _DropdownTopicWidgetState extends State<DropdownTopicWidget> {
  PostService postService = PostService();
  List<String> topics = [""];
  String _selectedItem = "";

  void getTopics() async {
    final receivedTopic = await postService.getTopics();

    setState(() {
      topics = topics + receivedTopic;
      if (topics.contains(widget.defaultTopic)) {
        _selectedItem = widget.defaultTopic;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedItem,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedItem = newValue;
          });
          widget.changeTopic(newValue);
        }
      },
      items: topics.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
