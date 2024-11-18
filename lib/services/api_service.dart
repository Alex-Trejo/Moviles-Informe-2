import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart'; // Importa la configuración base

class ApiService {
  final storage = FlutterSecureStorage();

  // Registrar usuario
  Future<Map<String, dynamic>> register(String nombre, String correo, String contrasena) async {
    final url = Uri.parse("${Config.baseUrl}register");
    
    // Realizamos la petición POST
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login
  Future<Map<String, dynamic>> login(String correo, String contrasena) async {
  final url = Uri.parse("${Config.baseUrl}login");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('token')) {
        await storage.write(key: "token", value: responseBody['token']);
      }
      return responseBody;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error en la solicitud: $e');
    rethrow; // Re-lanza la excepción para manejarla más arriba si es necesario
  }
}

  // Obtener lista de usuarios (requiere autenticación)
   Future<List<dynamic>> getUsers() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${Config.baseUrl}getUsers'),  // Usando la URL base y el endpoint
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los usuarios');
    }
  }

  // Método para obtener un solo usuario por ID
  Future<Map<String, dynamic>> getUser(int userId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${Config.baseUrl}getUser&id=$userId'),  // Usando la URL base y pasando el ID en la query
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }



  // Actualizar usuario (requiere autenticación)
  Future<Map<String, dynamic>> updateUser(int id, String nombre, String correo) async {
    final token = await storage.read(key: "token");
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("${Config.baseUrl}update");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Autenticación con el token
      },
      body: jsonEncode({
        "id": id,
        "nombre": nombre,
        "correo": correo,
      }),
    );

    return jsonDecode(response.body);
  }

  // Eliminar usuario (requiere autenticación)
  Future<Map<String, dynamic>> deleteUser(int id) async {
    final token = await storage.read(key: "token");
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("${Config.baseUrl}delete");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Autenticación con el token
      },
      body: jsonEncode({"id": id}),
    );

    return jsonDecode(response.body);
  }

  // Método para obtener los datos del usuario utilizando el token JWT
  Future<Map<String, dynamic>> getUserByToken(String token) async {
    final url = Uri.parse("${Config.baseUrl}getUserByToken");  // Asegúrate de que la URL sea correcta en tu backend

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Se pasa el token JWT en el encabezado
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);  // Devuelve los datos del usuario
      } else {
        throw Exception('Error al obtener los datos del usuario');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      rethrow;  // Propaga el error para que pueda ser manejado arriba
    }
  }


  

}
