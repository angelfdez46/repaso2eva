import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repaso2eva/navigation/navigation_bar_page.dart';
import 'package:repaso2eva/navigation/tabs_page.dart';
import 'package:repaso2eva/pages/authentication/register_page.dart';
import 'package:repaso2eva/pages/multimedia/multimedia_page.dart';

import '../pages/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Menú',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    if (user != null)
                      Text(
                        user.email ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),

              // 🏠 Home
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                  onTap: () {
                    context.go('/');
                },
              ),

              // 🔐 NO logueado
              if (user == null) ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text('Registro'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                ),
              ],

              // 🔓 Logueado
              if (user != null)
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    context.go('/');
                  },
                ),
              ListTile(
                leading: const Icon(Icons.perm_media),
                title: const Text('Multimedia'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MultimediaPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.tab),
                title : const Text('Tabs'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TabsPage()),
                  );
                }
              ),
              ListTile(
              leading: const Icon(Icons.tab),
                  title : const Text('Navigation bar'),
                  onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NavigationBarPage()),
                   );
                }
              ),
              ListTile(
                  leading: const Icon(Icons.home),
                   title: const Text('deep_linking'),
                    onTap: () {
                    Navigator.pop(context);
                    context.go('/deep_linking');
                 },
              )
            ],
          ),
        );
      },
    );
  }
}
