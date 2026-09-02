import 'package:flutter/material.dart';
import 'services/alimentos_service.dart';
import 'services/consumos_service.dart';
import 'home_page.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  String tipoComida = 'Desayuno';
List<dynamic> alimentos = [];
 int? alimentoSeleccionadoId;
 int? porcionSeleccionadaId;
  final alimentoController = TextEditingController();
  final cantidadController = TextEditingController();
 List<dynamic> porciones = [];
@override
void initState() {
  super.initState();
  cargarAlimentos();
}
  @override
  void dispose() {
    alimentoController.dispose();
    cantidadController.dispose();
    super.dispose();
  }
  Future<void> buscarAlimentos(String nombre) async {
  if (nombre.isEmpty) return;

  final resultado = await AlimentosService.buscarAlimentos(nombre);

  print('BUSQUEDA: $nombre');
  print('RESULTADOS: $resultado');

  setState(() {
    alimentos = resultado;
  });
}
 Future<void> cargarAlimentos() async {
  final resultado = await AlimentosService.buscarAlimentos('');

  setState(() {
    alimentos = resultado;
  });
}
Future<void> cargarPorciones(int idAlimento) async {
  print('ID ALIMENTO PARA PORCIONES: $idAlimento');

  final resultado =
      await AlimentosService.obtenerPorciones(idAlimento);

  print('PORCIONES RECIBIDAS: $resultado');

  setState(() {
    porciones = resultado;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9F2),
        elevation: 0,
        title: const Text(
          'Registrar comida',
          style: TextStyle(
            color: Color(0xFF263B20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registra lo que has comido',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Agrega un alimento y la cantidad consumida.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tipo de comida',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: tipoComida,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Desayuno',
                  child: Text('Desayuno'),
                ),
                DropdownMenuItem(
                  value: 'Almuerzo',
                  child: Text('Almuerzo'),
                ),
                DropdownMenuItem(
                  value: 'Cena',
                  child: Text('Cena'),
                ),
                DropdownMenuItem(
                  value: 'Snack',
                  child: Text('Snack'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tipoComida = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Alimento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),

            const SizedBox(height: 8),

            Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<String>.empty();
    }

    return alimentos
        .map<String>((alimento) => alimento['nombre'].toString())
        .where((nombre) => nombre
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
  },
 onSelected: (String nombre) async {
  alimentoController.text = nombre;

  final alimento = alimentos.firstWhere(
    (a) => a['nombre'].toString() == nombre,
  );

  if (alimento['idAlimento'] == 0) {
    final resultado = await AlimentosService.importarAlimento(
      nombre: alimento['nombre'],
      caloriasPor100g:
          (alimento['caloriasPor100g'] as num).toDouble(),
      proteinas:
          (alimento['proteinas'] as num?)?.toDouble(),
      carbohidratos:
          (alimento['carbohidratos'] as num?)?.toDouble(),
      grasas:
          (alimento['grasas'] as num?)?.toDouble(),
    );

    setState(() {
      alimentoSeleccionadoId = resultado['idAlimento'];
    });

    await cargarPorciones(alimentoSeleccionadoId!);
  } else {
    setState(() {
      alimentoSeleccionadoId = alimento['idAlimento'];
    });

    await cargarPorciones(alimentoSeleccionadoId!);
  }
},
  fieldViewBuilder: (
    context,
    controller,
    focusNode,
    onFieldSubmitted,
  ) {
  return TextField(
  controller: controller,
  focusNode: focusNode,
  onChanged: (value) {
    buscarAlimentos(value);
  },
  decoration: InputDecoration(
    hintText: 'Ej. arroz, pollo, manzana...',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);
  },
),
            const SizedBox(height: 24),

            const Text(
              'Cantidad (gramos)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B20),
              ),
            ),
            if (porciones.isNotEmpty)
  DropdownButtonFormField<dynamic>(
    decoration: InputDecoration(
      hintText: 'Selecciona una porción',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    items: porciones.map((porcion) {
      return DropdownMenuItem<dynamic>(
        value: porcion,
        child: Text(
          '${porcion['nombre']} (${porcion['gramos']} g)',
        ),
      );
    }).toList(),
    onChanged: (porcion) {
  if (porcion != null) {
    porcionSeleccionadaId = porcion['idPorcion'];

    cantidadController.text = porcion['gramos'].toString();
  }
},
  ),

            const SizedBox(height: 8),

            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ej. 100',
                suffixText: 'g',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
             onPressed: () async {
  if (alimentoSeleccionadoId == null ||
      porcionSeleccionadaId == null ||
      cantidadController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Completa los datos de la comida'),
      ),
    );
    return;
  }

  try {
    await ConsumosService.registrarConsumo(
      idAlimento: alimentoSeleccionadoId!,
      idPorcion: porcionSeleccionadaId!,
      tipoComida: tipoComida,
      cantidad: double.parse(cantidadController.text),
    );

    if (!mounted) return;
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const HomePage(),
  ),
);

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo registrar la comida'),
      ),
    );
  }
},
                icon: const Icon(Icons.add),
                label: const Text(
                  'Agregar comida',
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