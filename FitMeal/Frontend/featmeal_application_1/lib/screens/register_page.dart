import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final nombreController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final edadController = TextEditingController();
final pesoController = TextEditingController();
final estaturaController = TextEditingController();

String? sexoSeleccionado;
String? actividadSeleccionada;
int? objetivoSeleccionado;
  @override
 Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: const Color(0xFFF8F9F2),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crea tu cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Completa tus datos para personalizar tu experiencia en FitMeal.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),
            TextField(
  controller: nombreController,
  decoration: const InputDecoration(
    labelText: 'Nombre',
    border: OutlineInputBorder(),
  ),
),
const SizedBox(height: 18),

            TextField(
  controller: emailController,
  decoration: const InputDecoration(
    labelText: 'Correo electrónico',
    border: OutlineInputBorder(),
  ),
),

            const SizedBox(height: 18),
TextField(
  controller: passwordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Contraseña',
    border: OutlineInputBorder(),
  ),
),

            const SizedBox(height: 18),

           TextField(
  controller: edadController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Edad',
    border: OutlineInputBorder(),
  ),
),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Sexo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Femenino',
                  child: Text('Femenino'),
                ),
                DropdownMenuItem(
                  value: 'Masculino',
                  child: Text('Masculino'),
                ),
              ],
             onChanged: (value) {
  setState(() {
    sexoSeleccionado = value;
  });
},
            ),

            const SizedBox(height: 18),

           TextField(
  controller: pesoController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Peso (kg)',
    border: OutlineInputBorder(),
  ),
),

            const SizedBox(height: 18),

           TextField(
  controller: estaturaController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Estatura (cm)',
    border: OutlineInputBorder(),
  ),
),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Nivel de actividad',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Sedentaria',
                  child: Text('Sedentaria'),
                ),
                DropdownMenuItem(
                  value: 'Ligera',
                  child: Text('Ligera'),
                ),
                DropdownMenuItem(
                  value: 'Moderada',
                  child: Text('Moderada'),
                ),
                DropdownMenuItem(
                  value: 'Alta',
                  child: Text('Alta'),
                ),
              ],
             onChanged: (value) {
  setState(() {
    actividadSeleccionada = value;
  });
},
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Objetivo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Bajar de peso'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Mantener peso'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Ganar peso'),
                ),
              ],
             onChanged: (value) {
  setState(() {
    objetivoSeleccionado = value;
  });
},
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
               onPressed: () async {
  print('BOTON PRESIONADO');

  try {
    final resultado = await AuthService.registrarUsuario(
      nombre: nombreController.text,
      email: emailController.text,
      password: passwordController.text,
      edad: int.parse(edadController.text),
      sexo: sexoSeleccionado!,
      peso: double.parse(pesoController.text),
      estatura: double.parse(estaturaController.text),
      actividad: actividadSeleccionada!,
      idObjetivo: objetivoSeleccionado!,
    );

  if (resultado) {
  print('REGISTRO EXITOSO');
  print('INTENTANDO IR AL LOGIN');

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );

} else {
  if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('No se pudo crear la cuenta'),
    ),
  );
}
  } catch (e) {
    print('ERROR: $e');
  }
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E23),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}