import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_/services/api_service.dart';  
import 'package:login_/Pages/PaginaRegistro.dart';
import 'package:login_/Pages/PaginaEstudiantes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  final ApiService apiService = ApiService(); // Crear una instancia de ApiService

   void Ingresar() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      var response = await apiService.login(
        _controllerUser.text,
        _controllerPassword.text,
      );

      setState(() {
        isLoading = false;
      });

      if (response != null && response.containsKey('token')) {
        // Si el login fue exitoso y hay un token
        Navigator.pushReplacementNamed(context, "/home");

      } else {
        setState(() {
          errorMessage = "Credenciales incorrectas";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error al intentar iniciar sesión. Intenta nuevamente.";
      });
    }
  }

  void NavegarPaginaRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controllerUser,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: Ingresar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.deepPurple,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Iniciar sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: NavegarPaginaRegistro,
                child: const Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
