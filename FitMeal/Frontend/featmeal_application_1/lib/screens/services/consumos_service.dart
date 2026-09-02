import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConsumosService {
 static const String baseUrl = 'https://10.0.2.2:7000';

  static Future<void> registrarConsumo({
    required int idAlimento,
    required int idPorcion,
    required String tipoComida,
    required double cantidad,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/api/Consumos'),
      headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
},
      body: jsonEncode({
        'idAlimento': idAlimento,
        'idPorcion': idPorcion,
        'tipoComida': tipoComida,
        'cantidad': cantidad,
      }),
    );

   if (response.statusCode != 200) {
  print('STATUS: ${response.statusCode}');
  print('RESPUESTA: ${response.body}');
  throw Exception('No se pudo registrar el consumo');
}
  }
  static Future<List<dynamic>> obtenerConsumosHoy() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.get(
    Uri.parse('$baseUrl/api/Consumos/hoy'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('No se pudieron obtener los consumos de hoy');
}
}