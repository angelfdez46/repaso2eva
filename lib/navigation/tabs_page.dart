import 'package:flutter/material.dart';

import '../pages/multimedia/video_page.dart';
import '../pages/multimedia/youtube_page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'imagen'),
              Tab(text: 'video local'),
              Tab(text: 'video YT'),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            // TAB 1
            Center(
              child: Image(
                image: AssetImage('assets/images/svg/basket.jpg'),
              ),
            ),

            // TAB 2
            VideoPage(),

            // TAB 3
            VideoYoutubePage(),
          ],
        ),
      ),
    );
  }
}
