import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../navigation/drawer_page.dart';
import '../../utils/permissions.dart';
import '../utils/snackbars.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _permissionCheck(); // comprobar permiso al iniciar
  }

  Future<void> _permissionCheck() async {
    // 1️⃣ Revisar el estado actual del permiso
    var status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      // Permiso ya concedido
      if (!mounted) return;
      snackBarShow(context, 'Permiso ya concedido. Continuar...');
      return;
    }

    // 2️⃣ Pedir permiso al usuario
    status = await Permission.locationWhenInUse.request();

    if (!mounted) return;

    if (status.isGranted) {
      // Usuario concedió el permiso
      snackBarShow(context, 'Permiso concedido. Continuar...');
    } else if (status.isDenied) {
      // Usuario denegó temporalmente
      snackBarShow(context, 'Permiso denegado. No se podrá continuar.');
    } else if (status.isPermanentlyDenied) {
      // Usuario denegó permanentemente
      snackBarShow(context, 'Permiso denegado permanentemente. Ve a ajustes.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PMDM Examen'),
      ),
      drawer: const DrawerPage(),
      body: const Center(
        child: Text(
          'Proyecto base del examen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}