import 'package:flutter/material.dart';
import 'meal_page.dart';
import 'services/consumos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 List<dynamic> consumos = [];
 double caloriasHoy = 0;
 double caloriasDesayuno = 0;
 double caloriasAlmuerzo = 0;
double caloriasCena = 0;
double caloriasSnack = 0;
 Future<void> cargarConsumos() async {
  final resultado = await ConsumosService.obtenerConsumosHoy();

print('CONSUMOS DE HOY: $resultado');

setState(() {
  consumos = resultado;

  caloriasHoy = consumos.fold<double>(
    0,
    (total, consumo) => total + (consumo['calorias'] as num).toDouble(),
  );
});
caloriasDesayuno = consumos
    .where((consumo) => consumo['tipoComida'] == 'Desayuno')
    .fold<double>(
      0,
      (total, consumo) =>
          total + (consumo['calorias'] as num).toDouble(),
    );
    caloriasAlmuerzo = consumos
    .where((consumo) => consumo['tipoComida'] == 'Almuerzo')
    .fold<double>(
      0,
      (total, consumo) =>
          total + (consumo['calorias'] as num).toDouble(),
    );

caloriasCena = consumos
    .where((consumo) => consumo['tipoComida'] == 'Cena')
    .fold<double>(
      0,
      (total, consumo) =>
          total + (consumo['calorias'] as num).toDouble(),
    );

caloriasSnack = consumos
    .where((consumo) => consumo['tipoComida'] == 'Snack')
    .fold<double>(
      0,
      (total, consumo) =>
          total + (consumo['calorias'] as num).toDouble(),
    );
}
@override
void initState() {
  super.initState();
  cargarConsumos();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),

      appBar: AppBar(
  backgroundColor: const Color(0xFFF8F9F2),
  elevation: 0,
  title: const Text(
    'FitMeal',
    style: TextStyle(
      color: Color(0xFF263B20),
      fontWeight: FontWeight.bold,
    ),
  ),
  actions: [
    TextButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: const Text(
        'Cerrar sesión',
        style: TextStyle(
          color: Color(0xFF263B20),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hola 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Este es tu resumen de hoy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            // RESUMEN DE CALORÍAS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F0D3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Calorías de hoy',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF526344),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
  '${caloriasHoy.toStringAsFixed(1)} kcal',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263B20),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'de tu meta diaria',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0,
                      minHeight: 10,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tus comidas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 16),

            _MealCard(
  icon: Icons.wb_sunny_outlined,
  title: 'Desayuno',
  calorias: caloriasDesayuno,
),

            const SizedBox(height: 12),

            _MealCard(
  icon: Icons.restaurant_outlined,
  title: 'Almuerzo',
  calorias: caloriasAlmuerzo,
),

            const SizedBox(height: 12),

           _MealCard(
  icon: Icons.nightlight_outlined,
  title: 'Cena',
  calorias: caloriasCena,
),

            const SizedBox(height: 12),

            _MealCard(
  icon: Icons.apple_outlined,
  title: 'Snack',
  calorias: caloriasSnack,
),

            const SizedBox(height: 24),

            // BOTÓN REGISTRAR COMIDA
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const MealPage(),
    ),
  );
},
                icon: const Icon(Icons.add),
                label: const Text(
                  'Registrar comida',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E23),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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

class _MealCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double calorias;

  const _MealCard({
    required this.icon,
    required this.title,
    required this.calorias,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E5D8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F0D3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B8E23),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),
          ),

         Text(
  '${calorias.toStringAsFixed(1)} kcal',
  style: const TextStyle(
    color: Colors.grey,
    fontSize: 14,
  ),
),
          const SizedBox(width: 8),

          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}