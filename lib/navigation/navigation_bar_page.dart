import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _index = 0;
  User? user;



  final List<Widget> _pages = const [
    Center(child: Text('Inicio')),
    Center(child: Text('Multimedia')),
    Center(child: Text('Perfil')),
  ];

  @override
  void initState() {
    super.initState();
    // Obtener usuario logueado
    user = FirebaseAuth.instance.currentUser;

    // Escuchar cambios de login/logout
    FirebaseAuth.instance.authStateChanges().listen((User? u) {
      setState(() {
        user = u;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Center(child: Text('Inicio')),
      Center(
        child: Image.asset(
          'assets/images/svg/basket.jpg',
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
      // Tab “Perfil”
      Center(
        child: user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user!.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/images/avatar.png')
              as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text('Nombre: ${user!.displayName ?? "No disponible"}'),
            Text('Email: ${user!.email ?? "No disponible"}'),
            Text('UID: ${user!.uid}'),
            Text('Registrado: ${user!.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? "No disponible"}'),
            Text('Correo verificado: ${user!.emailVerified ? "Sí" : "No"}'),
          ],
        )
            : const Text('No logueado'),
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_index != 0) {
          setState(() {
            _index = 0;
          });
          return false;
        }
        return true;
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
