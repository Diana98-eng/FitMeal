import 'dart:convert';
import 'package:http/http.dart' as http;

class AlimentosService {
  static const String baseUrl = 'https://10.0.2.2:7000';

  static Future<List<dynamic>> buscarAlimentos(String nombre) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/Alimentos/buscar?nombre=$nombre'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}
  static Future<List<dynamic>> obtenerPorciones(int idAlimento) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/Alimentos/$idAlimento/porciones'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('No se pudieron obtener las porciones');
}
static Future<Map<String, dynamic>> importarAlimento({
  required String nombre,
  required double caloriasPor100g,
  double? proteinas,
  double? carbohidratos,
  double? grasas,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/Alimentos/importar'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'nombre': nombre,
      'caloriasPor100g': caloriasPor100g,
      'proteinas': proteinas,
      'carbohidratos': carbohidratos,
      'grasas': grasas,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('No se pudo importar el alimento');
}
}