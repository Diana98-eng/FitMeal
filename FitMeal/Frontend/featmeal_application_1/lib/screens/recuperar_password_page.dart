import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'restablecer_password_page.dart';

class RecuperarPasswordPage extends StatefulWidget {
  const RecuperarPasswordPage({super.key});

  @override
  State<RecuperarPasswordPage> createState() =>
      _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState
    extends State<RecuperarPasswordPage> {

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),

      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
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
              'Recupera tu contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Ingresa el correo electrónico asociado a tu cuenta.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
               onPressed: () async {
  final email = emailController.text.trim();

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingresa tu correo electrónico'),
      ),
    );
    return;
  }

  try {
    final enviado = await AuthService.solicitarRecuperacion(
      email: email,
    );

    if (!mounted) return;

    if (enviado) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RestablecerPasswordPage(
        email: email,
      ),
    ),
  );
 } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existe una cuenta con ese correo'),
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
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
                  'Continuar',
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