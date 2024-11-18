import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Pages/PaginaLogin.dart';
import 'Pages/PaginaEstudiantes.dart';
import 'Pages/PaginaRegistro.dart';// Asegúrate de importar las páginas necesarias

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _checkLogin() async {
  final token = await FlutterSecureStorage().read(key: 'token');
  return token != null;
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: "Login",
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      useMaterial3: true,
    ),
    initialRoute: "/login",
    routes: {
      "/login": (context) => const Login(),
      "/home": (context) => const TablaEstudiantes(),
      "/registro": (context) => const Registro(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == '/home') {
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<bool>(
            future: _checkLogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data == true) {
                return const TablaEstudiantes();
              } else {
                return const Login(); // Redirigir si no hay sesión
              }
            },
          ),
        );
      }
      return null; // Manejar otras rutas si es necesario
    },
  );
}
}