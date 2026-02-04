import 'package:flutter/material.dart';

import 'drawer_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _index = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Inicio')),
    Center(child: Text('Multimedia')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index != 0) {
          setState(() {
            _index = 0;
          });
          return false;
        }
        return true; // vuelve a Home si hay pila
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('NavigationBar')),
        drawer: const DrawerPage(),
        body: _pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) {
            setState(() {
              _index = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.image),
              label: 'Media',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
