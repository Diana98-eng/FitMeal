import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://fitmeal-kq25.onrender.com';
  
  static Future<bool> registrarUsuario({
  required String nombre,
  required String email,
  required String password,
  required int edad,
  required String sexo,
  required double peso,
  required double estatura,
  required String actividad,
  required int idObjetivo,
}) async {
  final datos = {
  'nombre': nombre,
  'email': email,
  'password': password,
  'edad': edad,
  'sexo': sexo,
  'peso': peso,
  'estatura': estatura,
  'actividad': actividad,
  'idObjetivo': idObjetivo,
};
final respuesta = await http.post(
  Uri.parse('$baseUrl/api/Auth/register'),
  headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode(datos),
);
  return respuesta.statusCode == 200;
  
}
static Future<Map<String, dynamic>?> login({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/api/Auth/login');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

if (response.statusCode == 200) {
  final datos = jsonDecode(response.body);

  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', datos['token']);
  await prefs.setInt('idUsuario', datos['idUsuario']);
  await prefs.setString('nombre', datos['nombre']);
  await prefs.setString('email', datos['email']);
  await prefs.setString('objetivo', datos['objetivo']);

  return datos;
}
  return null;
}
static Future<bool> solicitarRecuperacion({
  required String email,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/Auth/solicitar-recuperacion'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
    }),
  );

  return response.statusCode == 200;
}
static Future<bool> restablecerPassword({
  required String email,
  required String codigo,
  required String nuevaPassword,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/Auth/restablecer-password'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'codigo': codigo,
      'nuevaPassword': nuevaPassword,
    }),
  );

  return response.statusCode == 200;
}
}

