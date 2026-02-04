import 'package:go_router/go_router.dart';
import 'package:repaso2eva/pages/authentication/login_page.dart';
import 'package:repaso2eva/pages/authentication/register_page.dart';
import '../home/home_page.dart';
import '../navigation/navigation_bar_page.dart';
import '../navigation/tabs_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/nav-bar',
      builder: (context, state) => const NavigationBarPage(),
    ),
    GoRoute(
      name: 'tabs',
      path: '/tabs',
      builder: (context, state) => const TabsPage(),
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
        path: '/register_page',
        builder: (context , state) => const RegisterPage(),
    ),
  ],
);
