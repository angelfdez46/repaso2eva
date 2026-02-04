import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/keyboard.dart';
import '../../utils/snackbars.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  // variable para el usuario actual
  User? _user;
  UserCredential? _userCredential;

  // variables para las suscripciones
  StreamSubscription<User?>? _userChangesSubscription;

  final _formEmailPasswordKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  // escucha los cambios en el usuario
  void _userChanges(User? user) {
    debugPrint('_userChanges: $user');
    setState(() {
      _user = user;
    });
  }

  // cerrar sesión
  void _signOut() {
    if (_user == null) {
      snackBarShow(context, 'No hay usuario autenticado');
      return;
    }

    // cerrar sesión
    FirebaseAuth.instance.signOut();
  }

  // borrar cuenta
  void _delete() {
    if (_user == null) {
      snackBarShow(context, 'No hay usuario autenticado');
      return;
    }

    // borrar cuenta
    FirebaseAuth.instance.currentUser?.delete();
  }

  // restablecer contraseña
  Future<void> _passwordReset() async {
    // validar formulario
    if (_formEmailPasswordKey.currentState?.validate() != true) return;
    _formEmailPasswordKey.currentState!.save();
    hideKeyboard();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!);

      if (mounted) snackBarShow(context, "Se ha enviado un correo para restablecer su contraseña.");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // verificar correo electrónico
  Future<void> _verifyEmail() async {
    if (_user == null) {
      snackBarShow(context, 'No hay usuario autenticado');
      return;
    }

    if (_user?.emailVerified == true) {
      snackBarShow(context, 'Correo verificado anteriormente');
      return;
    }

    try {
      await _user?.sendEmailVerification();

      if (mounted) snackBarShow(context, "Se ha enviado un correo para verificar su cuenta.");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // autenticación con correo electrónico y contraseña
  Future<void> _loginEmailPassword() async {
    if (_user != null) {
      snackBarShow(context, 'Ya hay usuario autenticado');
      return;
    }

    // validar formulario
    if (_formEmailPasswordKey.currentState?.validate() != true) return;
    _formEmailPasswordKey.currentState!.save();
    hideKeyboard();

    try {
      _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      // UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: false, profile: {}, providerId: null, username: null, authorizationCode: null), credential: null, user: User(displayName: null, email: a@a.com, isEmailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2026-01-15 15:12:01.416Z, lastSignInTime: 2026-01-15 15:17:33.275Z), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: a@a.com, phoneNumber: null, photoURL: null, providerId: password, uid: a@a.com)], refreshToken: null, tenantId: null, uid: ItKtqjmMPSXd46jycNdyfJ5rItJ3))
      debugPrint('_loginEmailPassword: $_userCredential');

      // opcional - cerrar sesion mientras que no está validado el correo
      // if (_userCredential?.user?.emailVerified == false) {
      //   FirebaseAuth.instance.signOut();
      //   if (mounted) snackBarShow(context, 'Por favor, verifique su dirección de correo');
      // }
    } on FirebaseAuthException catch (e) {
      debugPrint('_loginEmailPassword: $e');
      String message = switch (e.code) {
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Wrong password provided for that user.',
        'invalid-credential' => 'Usuario y/o contraseña incorrectas',
        _ => e.message ?? '',
      };
      if (mounted) snackBarShow(context, message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // autenticación con correo electrónico y contraseña
  Future<void> _registerEmailPassword() async {
    if (_user != null) {
      snackBarShow(context, 'Ya hay usuario autenticado');
      return;
    }

    // validar formulario
    if (_formEmailPasswordKey.currentState?.validate() != true) return;
    _formEmailPasswordKey.currentState!.save();
    hideKeyboard();

    try {
      _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      // UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile: {}, providerId: null, username: null, authorizationCode: null), credential: null, user: User(displayName: null, email: a@a.com, isEmailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2026-01-15 15:18:10.089Z, lastSignInTime: 2026-01-15 15:18:10.089Z), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: a@a.com, phoneNumber: null, photoURL: null, providerId: password, uid: a@a.com)], refreshToken: null, tenantId: null, uid: 5QTfrBN0v0g1y2HkwwbANEazPTg2))
      debugPrint('_registerEmailPassword: $_userCredential');

      User? user = _userCredential?.user;
      if (user != null) {
        // enviar correo para que verifique su cuenta
        await _userCredential?.user?.sendEmailVerification();

        // opcional - cerrar sesión mientras no verifique su cuenta
        FirebaseAuth.instance.signOut();

        if (mounted) snackBarShow(context, "Se ha enviado un correo para verificar su cuenta.");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('_registerEmailPassword: $e');
      String message = switch (e.code) {
        'email-already-in-use' => 'La cuenta ya existe para ese correo electrónico.',
        _ => e.message ?? '',
      };
      if (mounted) snackBarShow(context, message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // autenticación anónima
  Future<void> _anonymous() async {
    if (_user != null) {
      snackBarShow(context, 'Ya hay usuario autenticado');
      return;
    }

    try {
      _userCredential = await FirebaseAuth.instance.signInAnonymously();
      // UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: false, profile: {}, providerId: null, username: null, authorizationCode: null), credential: null, user: User(displayName: null, email: null, isEmailVerified: false, isAnonymous: true, metadata: UserMetadata(creationTime: 2026-01-14 11:38:25.892Z, lastSignInTime: 2026-01-14 11:38:25.892Z), phoneNumber: null, photoURL: null, providerData, [], refreshToken: null, tenantId: null, uid: zwj3bKy84BUwFcYG9Et3uBdpIZe2))
      debugPrint('_anonymous: $_userCredential');
    } on FirebaseAuthException catch (e) {
      debugPrint('_anonymous: $e');
      if (mounted) snackBarShow(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    // escuchar las actualizaciones en tiempo real del estado del usuario (inicio de sesión, cierre de sesión, actualización de usuario y token) y luego rehidratar los cambios en la aplicación.
    _userChangesSubscription = FirebaseAuth.instance.userChanges().listen(
      _userChanges,
    );
  }

  @override
  void dispose() {
    // cancelar todas las suscripciones
    _userChangesSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Authentication'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proveedor: ${_user?.providerData.firstOrNull?.providerId ?? (_user != null ? 'anónimo' : '')}',
                ),
                Text(
                  'Identificador: ${_user?.providerData.firstOrNull?.uid ?? ''}',
                ),
                Text('UID: ${_user?.uid ?? ''}'),
                Text('Es anónimo: ${_user?.isAnonymous ?? ''}'),
                Text('Correo: ${_user?.email ?? ''}'),
                Text('Correo verificado: ${_user?.emailVerified ?? ''}'),
                Text(
                  'Creado: ${_user?.metadata.creationTime?.toLocal() ?? ''}',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ElevatedButton(
              onPressed: _anonymous,
              child: Text('Autenticación anónima'),
            ),
          ),
          Form(
            key: _formEmailPasswordKey,
            autovalidateMode: .always,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: TextFormField(
                    initialValue: 'antoniojose.garcia8@murciaeduca.es',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty != false) return 'Obligatorio';
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: TextFormField(
                    initialValue: '123456',
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty != false) return 'Obligatorio';
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    onPressed: _registerEmailPassword,
                    child: Text('Registrar con correo electrónico y contraseña'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    onPressed: _loginEmailPassword,
                    child: Text('Acceder con correo electrónico y contraseña'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    onPressed: _verifyEmail,
                    child: Text('Verificar correo electrónico'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    onPressed: _passwordReset,
                    child: Text('Restablecer contraseña'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ElevatedButton(
              onPressed: _signOut,
              child: Text('Cerrar sesión'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ElevatedButton(
              onPressed: _delete,
              child: Text('Borrar usuario'),
            ),
          ),
        ],
      ),
    );
  }
}