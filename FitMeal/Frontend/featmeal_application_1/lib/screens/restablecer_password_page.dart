import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class RestablecerPasswordPage extends StatefulWidget {
  final String email;

  const RestablecerPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<RestablecerPasswordPage> createState() =>
      _RestablecerPasswordPageState();
}

class _RestablecerPasswordPageState
    extends State<RestablecerPasswordPage> {

  final codigoController = TextEditingController();
  final nuevaPasswordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),

      appBar: AppBar(
        title: const Text('Nueva contraseña'),
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
              'Restablece tu contraseña',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Ingresa el código que recibiste y crea una nueva contraseña.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código de recuperación',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nuevaPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmarPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final codigo = codigoController.text.trim();
                  final nuevaPassword =
                      nuevaPasswordController.text;
                  final confirmarPassword =
                      confirmarPasswordController.text;

                  if (codigo.isEmpty ||
                      nuevaPassword.isEmpty ||
                      confirmarPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Completa todos los campos',
                        ),
                      ),
                    );
                    return;
                  }

                  if (nuevaPassword != confirmarPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Las contraseñas no coinciden',
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    final resultado =
                        await AuthService.restablecerPassword(
                      email: widget.email,
                      codigo: codigo,
                      nuevaPassword: nuevaPassword,
                    );

                    if (!mounted) return;

                    if (resultado) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Contraseña actualizada correctamente',
                          ),
                        ),
                      );

                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'El código no es válido o ha expirado',
                          ),
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
                  'Cambiar contraseña',
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