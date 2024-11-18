import 'package:flutter/material.dart';
import 'package:login_/Pages/PaginaLogin.dart';
import 'package:login_/services/api_service.dart';


class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<StatefulWidget> createState() => RegistroState();
}

class RegistroState extends State<Registro> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  final ApiService apiService = ApiService();

  void Registrar() async {
    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorMessage = "Las contraseñas no coinciden";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    var response = await apiService.register(
      _controllerUser.text, _controllerEmail.text, _controllerPassword.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      setState(() {
        errorMessage = "Error al registrar";
      });
    }
  }

  void NavegarPaginaInicio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registro de Estudiantes",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear una cuenta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controllerUser,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controllerConfirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: Registrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.teal,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrarse', style: TextStyle(fontSize: 18)),
              ),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: NavegarPaginaInicio,
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
