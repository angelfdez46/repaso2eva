import 'package:go_router/go_router.dart';
import 'package:repaso2eva/navigation/deep_linking.dart';
import 'package:repaso2eva/pages/authentication/login_page.dart';
import 'package:repaso2eva/pages/authentication/register_page.dart';
import 'package:repaso2eva/pages/multimedia/audio_page.dart';
import 'package:repaso2eva/pages/multimedia/image_camera.dart';
import 'package:repaso2eva/pages/multimedia/image_page.dart';
import 'package:repaso2eva/pages/multimedia/video_url.dart';
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
    GoRoute(
        name: 'imagenes',
        path: '/image_page',
        builder: (context, state) => const ImagePage(),
    ),
    GoRoute(
        name: 'videourl',
        path: '/videourl',
      builder: (context, state) => const VideoUrlPage(),
    ),
    GoRoute(
      name: 'image_camera',
      path: '/image_camera',
      builder: (context, state) => const ImageCameraPage(),
    ),
    GoRoute(
      name: 'audio',
      path: '/audio_page',
      builder: (context, state) => const AudioPage(),
    ),
    GoRoute(
      name: 'deep_linking',
      path: '/deep_linking',
      builder: (context, state) => const DeepLinkingPage(id: '',),
    ),
  ],
);
