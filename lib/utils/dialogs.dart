import 'package:flutter/material.dart';

Future<void> dialogShow(BuildContext context, String content, {String? title}) {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: title?.isNotEmpty == true ? Text(title!) : null,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

Future<int?> dialogShowYesNo(BuildContext context, String content, {String? title = 'Confirmación'}) {
  return showDialog<int?>(
    context: context,
    builder: (_) => AlertDialog(
      title: title?.isNotEmpty == true ? Text(title!) : null,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 1),
          child: const Text('Sí'),
        ),
      ],
    ),
  );
}