import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialogs.dart';
import 'snackbars.dart';

Future<bool> permissionHandle(BuildContext context, Permission permission, String name, String message) async {
  // comprobar el estado
  PermissionStatus status = await permission.status;

  debugPrint('$permission: ${status.name}');

  if (status == .permanentlyDenied) {
    if (context.mounted) {
      // denegado totalmente, ya no se puede seguir pidiendo, el usuario tiene que concederlo desde los ajustes
      final res = await dialogShowYesNo(
        context,
        "El permiso '$name' está permanentemente denegado.\n\n¿Quieres abrir los ajustes para habilitarlo?",
      );
      if (res == 1) openAppSettings();
    }

    return false;
  }

  // solicitar permiso
  status = await permission
      .onDeniedCallback(() {
    // permiso denegado, se puede solicitar más veces (en Android se puede denegar 2 veces hasta considerarlo denegado totalmente)
  })
      .onGrantedCallback(() {
    // permiso concedido
  })
      .onLimitedCallback(() {
    // permiso concedido, parcialmente
  })
      .onPermanentlyDeniedCallback(() async {
    // denegado totalmente, ya no se puede seguir pidiendo, el usuario tiene que concederlo desde los ajustes
  })
      .onProvisionalCallback(() {
    // permiso concedido, provisionalmente
  })
      .onRestrictedCallback(() {
    // permiso restringido
    if (context.mounted) snackBarShow(context, "El permiso '$name' está restringido");
  })
      .request();

  debugPrint('$permission: ${status.name}');

  // devolver true solo si el permiso está concedido
  final res = status == .granted || status == .limited || status == .provisional;

  // si no está concedido y debería mostrar una explicación, mostrar un mensaje
  if (!res && true == (await permission.shouldShowRequestRationale)) {
    if (context.mounted) {
      dialogShow(context, message, title: 'Información');
    }
  }

  return res;
}