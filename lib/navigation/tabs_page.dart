import 'package:flutter/material.dart';

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
              Tab(text: 'Uno'),
              Tab(text: 'Dos'),
              Tab(text: 'Tres'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Tab 1')),
            Center(child: Text('Tab 2')),
            Center(child: Text('Tab 3')),
          ],
        ),
      ),
    );
  }
}
