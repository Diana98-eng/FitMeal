import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'home_page.dart';
import 'recuperar_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: const Color(0xFFF8F9F2),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            const Text(
              'Bienvenida a FitMeal',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Ingresa a tu cuenta para continuar.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 35),

            TextField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(
    labelText: 'Correo electrónico',
    border: OutlineInputBorder(),
  ),
),
const SizedBox(height: 30),

TextField(
  controller: passwordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Contraseña',
    border: OutlineInputBorder(),
  ),
),



const SizedBox(height: 8),

Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecuperarPasswordPage(),
        ),
      );

    },
    child: const Text(
      '¿Olvidaste tu contraseña?',
      style: TextStyle(
        color: Color(0xFF6B8E23),
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 20),
           
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
               onPressed: () async {
  print('BOTON LOGIN PRESIONADO');

try {
  final resultado = await AuthService.login(
    email: emailController.text,
    password: passwordController.text,
  );

  if (resultado != null) {
    print('LOGIN EXITOSO');
    print('USUARIO: ${resultado['nombre']}');
    

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inicio de sesión exitoso'),
      ),
      
    );
    Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const HomePage(),
  ),
);
  } else {
    print('LOGIN FALLIDO');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Correo o contraseña incorrectos'),
      ),
    );
  }
} catch (e) {
  print('ERROR LOGIN: $e');

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error al iniciar sesión: $e'),
    ),
  );
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
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}