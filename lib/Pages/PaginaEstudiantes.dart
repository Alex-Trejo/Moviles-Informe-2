import 'package:flutter/material.dart';
import 'package:login_/services/api_service.dart'; // Importa ApiService
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Para leer el token
import 'package:login_/Pages/PaginaLogin.dart'; // Importa la página de login

class TablaEstudiantes extends StatefulWidget {
  const TablaEstudiantes({super.key});

  @override
  State<StatefulWidget> createState() => TablaEstudiantesState();
}

class TablaEstudiantesState extends State<TablaEstudiantes> {
  final ApiService apiService = ApiService();
  Map<String, dynamic> user = {};
  bool isLoading = true;  // Estado de carga

  // Cargar los datos del usuario logeado
  void cargarUsuario() async {
    try {
      // Leer el token almacenado en Flutter Secure Storage
      final token = await FlutterSecureStorage().read(key: 'token');
      print("Token leído: $token");

      if (token != null) {
        // Obtener los datos del usuario logeado usando el token
        Map<String, dynamic> userData = await apiService.getUserByToken(token);
        print("Datos del usuario: $userData");

        setState(() {
          user = userData;  // Almacenar los datos del usuario logeado
          isLoading = false; // Ya no está cargando
        });
      } else {
        throw Exception("No hay token almacenado, el usuario no está logeado.");
      }
    } catch (e) {
      print("Error al cargar usuario: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() {
        isLoading = false; // Ya no está cargando
      });
      // Redirigir al login si no hay token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void actualizarUsuario() async {
    TextEditingController nombreController = TextEditingController(text: user['nombre']);
    TextEditingController correoController = TextEditingController(text: user['correo']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Actualizar Usuario"),
          content: Container(
            width: 600, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: correoController,
                  decoration: InputDecoration(labelText: "Correo"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Convertir el id a entero antes de enviarlo
                  final int userId = int.parse(user['id'].toString());
                  Map<String, dynamic> response = await apiService.updateUser(
                    userId, 
                    nombreController.text,
                    correoController.text,
                  );
                  if (response['message'] == "Usuario actualizado exitosamente") {
                    setState(() {
                      user['nombre'] = nombreController.text;
                      user['correo'] = correoController.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
                  }
                  Navigator.pop(context);
                  cargarUsuario(); // Volver a cargar los datos del usuario
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void eliminarUsuario() async {
    // Mostrar un cuadro de diálogo de confirmación
    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Usuario"),
          content: const Text("¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cerrar diálogo con false
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true), // Cerrar diálogo con true
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    // Verifica si 'confirmar' es null, y si lo es, trata el caso como 'false'
    if (confirmar == null || !confirmar) {
      print("Operación cancelada o el valor es nulo.");
      return; // Salir si no se confirma
    }

    if (confirmar) {
      try {
        // Convertir el id a entero antes de enviarlo
        final int userId = int.parse(user['id'].toString());
        print("Entrando a eliminar");
        // Llamar al servicio de eliminación
        Map<String, dynamic> response = await apiService.deleteUser(userId);
        print("Respuesta del servidor: $response"); // Verifica la respuesta completa

        // Mostrar mensaje de éxito o error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));

        if (response['message'] == "Usuario eliminado correctamente") {
          // Limpiar el token almacenado
          await const FlutterSecureStorage().delete(key: 'token');
          print("Usuario eliminado exitosamente");
          // Redirigir al login y limpiar la pila de navegación
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()), // Redirigir al login
            (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cargarUsuario(); // Cargar los datos del usuario logeado al inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Perfil del Estudiante',
    style: TextStyle(
      fontSize: 22, // Tamaño de la fuente
      fontWeight: FontWeight.bold, // Negrita
      color: Colors.white, // Color del texto
    ),
  ),
  backgroundColor: Colors.deepPurple, // Color de fondo del AppBar
  elevation: 10, // Sombra para darle un efecto de elevación
  shadowColor: Colors.black.withOpacity(0.3), // Color y opacidad de la sombra
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400], // Gradiente de color
      ),
    ),
  ),
),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user.isEmpty
              ? Center(child: Text('No se encontraron datos del usuario.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${user['nombre']}', style: TextStyle(fontSize: 18)),
                      Text('Correo: ${user['correo']}', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: actualizarUsuario,
                            child: const Text("Actualizar"),
                          ),
                          ElevatedButton(
                            onPressed: eliminarUsuario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Eliminar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

