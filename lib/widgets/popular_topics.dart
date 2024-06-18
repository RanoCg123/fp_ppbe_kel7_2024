import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/services/post_service.dart';

import '../models/topic_model.dart';

import '../screens/search_post_screen.dart';

class PopularTopics extends StatefulWidget {
  @override
  State<PopularTopics> createState() => _PopularTopicsState();
}

class _PopularTopicsState extends State<PopularTopics> {
  List<Color> colors = [
    Colors.purple,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent
  ];
  List<Topic>? popularTopics;
  final postService = PostService();
  bool isLoaded = true;

  void getPopularTopic() async {
    setState(() {
      isLoaded = true;
    });

    final topics = await postService.getPopularTopic(5);

    setState(() {
      popularTopics = topics;
      isLoaded = false;
    });
  }

  void goToSearchPostPage({
    String searched = "",
    String topic = "",
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchPostPage(
          topic: topic,
          searched: searched,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPopularTopic();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: isLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularTopics!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    goToSearchPostPage(topic: popularTopics![index].name);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(left: 20.0),
                    height: 180,
                    width: 170,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            popularTopics![index].name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            popularTopics![index].num.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: .7),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
