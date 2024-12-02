import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FeetHealthy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Colors.teal.shade600,
            primaryContainer: Colors.grey.shade900
          )
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() { 
    current = WordPair.random();
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const TypesPage();
        break;
      case 2:
        page = const HelpPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar( 
            toolbarHeight: 49,//Encabezado
            flexibleSpace: Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.teal.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                ),
              ),
            ),
            title: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20, // Tamaño del texto
                  color: Colors.white, // Color del texto
                  fontWeight: FontWeight.bold, // Peso del texto
                ),
                children: [
                  const TextSpan(text: 'Healthy '),
                  WidgetSpan(
                  child: Image.asset(
                    'assets/feetlogo.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                  const TextSpan(text: ' Feet'),
                ], 
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Contexto del Scaffold
                  },
                );
              },
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 135, // Altura personalizada
                  child: DrawerHeader(
                    margin: EdgeInsets.zero, // Eliminar márgenes predeterminados
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade900, Colors.teal.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Imagen de fondo
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.3, // Ajusta la transparencia de la imagen
                            child: Image.asset(
                              'assets/feetlogo.png', // Ruta de tu imagen
                              fit: BoxFit.cover, // La imagen cubrirá todo el espacio disponible
                            ),
                          ),
                        ),
                        // Texto sobre la imagen
                        Center(
                          child: Text(
                            'Menú de opciones',
                            style: TextStyle(
                              fontSize: 20, // Tamaño del texto ajustado
                              color: Colors.white, // Color del texto
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5), // Sombra para mejorar la legibilidad
                                  offset: const Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Principal'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    Navigator.pop(context); // Cierra el Drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: const Text('Tipos de pies'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outlined),
                  title: const Text('Dudas'),
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Opacity(
                    opacity: 0.5, // Ajusta el nivel de opacidad (0.0 a 1.0)
                    child: Image.asset(
                      'assets/icon.png', // Ruta de tu imagen
                      height: 460, // Altura personalizada para la imagen
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Row(
            children: [
              if (constraints.maxWidth >= 600) // Mostrar NavigationRail solo en pantallas anchas
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.format_list_numbered),
                        label: Text('Types'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.help_outlined),
                        label: Text('Help'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  File? _image; // Variable para almacenar la imagen capturada
  final ImagePicker _picker = ImagePicker(); // Instancia de ImagePicker

  // Método para capturar foto
  // Método para seleccionar foto desde el directorio
  Future<void> _selectPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _image = File(photo.path); // Asignar la imagen seleccionada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade900, Colors.teal.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: RichText(
          textAlign: TextAlign.left,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: 'Principal '),
              WidgetSpan(
                child: Icon(Icons.home, color: Colors.white, size: 35),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Centre las plantas de los pies en el recuadro:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
                letterSpacing: 1.4,
                shadows: [
                  Shadow(
                    offset: const Offset(3, 3),
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Cuadro para previsualizar la imagen
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal.shade600, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _image == null
                  ? Center(
                      child: Text(
                        'No hay foto aún',
                        style: TextStyle(
                          color: Colors.teal.shade600,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          _image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _image = null; // Eliminar la imagen
                            });
                          },
                          tooltip: 'Eliminar foto',
                          splashRadius: 20,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectPhoto, // Llama al método para seleccionar foto
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade50,
                foregroundColor: Colors.teal.shade800,
                elevation: 5,
                shadowColor: Colors.teal.shade100,
              ),
              child: const Text('Seleccionar fotografía de muestra'),
            ),
          ],
        ),
      ),
    );
  }
}


class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade900, Colors.teal.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: RichText(
          textAlign: TextAlign.left,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 30, // Tamaño del texto
              color: Colors.white, // Color del texto
            ),
            children: [
              TextSpan(text: 'Tipos de pies '),
              WidgetSpan(
                child: Icon(Icons.list_alt_outlined, color: Colors.white, size: 35),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // Título ¡Bienvenido!
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 28, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Negrita
                color: Colors.teal.shade800, // Color del texto
                fontStyle: FontStyle.italic, // Cursiva
                letterSpacing: 2.0, // Espaciado entre letras
                shadows: [
                  Shadow(
                    offset: const Offset(3, 3), // Posición de la sombra
                    color: Colors.black.withOpacity(0.3), // Color y opacidad de la sombra
                    blurRadius: 5, // Difuminado de la sombra
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Alineación central
            ),
          ),
          // Imágenes con texto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aquí te mostramos algunos tipos de pies que existen, así como sus especificaciones y ejemplos de referencia:',
                  style: TextStyle(
                    fontSize: 15, // Tamaño de fuente
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15),
                _buildImageWithText(
                  'assets/normal.png', 
                  'Pie Normal:',
                ),
                const SizedBox(height: 10),
                const Text(
                  '- El arco plantar está dentro de los límites normales.\n\n- La carga de peso se distribuye equilibradamente.\n\n- No hay síntomas de dolor o fatiga.',
                  style: TextStyle(
                    fontSize: 14, // Tamaño de fuente
                    height: 0.7,
                  ),
                  textAlign: TextAlign.justify,
                ), // Espaciado entre las filas
                const SizedBox(height: 40,),
                _buildImageWithText(
                  'assets/plano.png',
                  'Pie Plano:',
                ),
                const SizedBox(height: 10,),
                const Text(
                  '- El arco plantar está aplanado, lo que provoca que la carga del peso se concentre en la parte anterior y posterior del pie.\n\n- Dolor de pie, tobillo y zona interna.\n\n- La marcha puede ser afectada, con un estilo de caminar más plano o “equino”.',
                  style: TextStyle(
                    fontSize: 14, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  'Tratamiento',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  '- El tratamiento puede incluir plantillas personalizadas, ejercicios para fortalecer los músculos del pie y tobillo, y el uso de calzado adecuado.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
                _buildImageWithText(
                  'assets/cavo.png',
                  'Pie Cavo:'
                ),
                const SizedBox(height: 10,),
                const Text(
                  '- El arco plantar es más alto de lo normal y no se puede aplanar.\n\n- La carga del peso se concentra en la zona del talón y metatarso (debajo de los dedos), lo que puede provocar dolor y fatiga en estas áreas.\n\n- Síntomas comunes incluyen dolor en el pie, tobillo y zona interna del pie, dedos en garra o martillo, callos y pérdida de flexión dorsal en el pie.\n\n- La marcha puede ser afectada, con un estilo de caminar más rígido o “equino”.',
                  style: TextStyle(
                    fontSize: 14, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  'Tratamiento',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  '- El tratamiento puede incluir plantillas personalizadas, ejercicios para fortalecer los músculos del pie y tobillo, y la cirugía en casos severos o con síntomas graves.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
                Text(
                  'Prevención',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  '- Evitar el uso inadecuado de calzado, como zapatos con soportes excesivos o sin suficiente apoyo en la zona del talón.\n\n- Realizar ejercicios para fortalecer los músculos del pie y tobillo.\n\n- Mantener un peso saludable y realizar actividades físicas regulares para mejorar la flexibilidad y la función del pie.\n\n- Realizar un examen regular del pie y buscar asesoramiento profesional si se presentan síntomas de dolor o fatiga en el pie o tobillo.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.shade200, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método reutilizable para crear una fila con imagen y texto
  Widget _buildImageWithText(String imagePath, String text) {
    return Row(
      children: [
        // Imagen
        ClipRRect(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        child: Image.asset(
          imagePath,
          width: 145,
          height: 78,
          fit: BoxFit.contain,
        ),
      ),
        const SizedBox(width: 20), // Espaciado entre imagen y texto
        // Texto
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade900, Colors.teal.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: RichText(
          textAlign: TextAlign.left,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 30, // Tamaño del texto
              color: Colors.white, // Color del texto
            ),
            children: [
              TextSpan(text: '¿Dudas? '),
              WidgetSpan(
                child: Icon(Icons.help_outline_rounded, color: Colors.white, size: 35),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // Título ¡Bienvenido!
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '¿Dudas? ¿Comentarios?',
              style: TextStyle(
                fontSize: 28, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Negrita
                color: Colors.teal.shade800, // Color del texto
                fontStyle: FontStyle.italic, // Cursiva
                letterSpacing: 2.0, // Espaciado entre letras
                shadows: [
                  Shadow(
                    offset: const Offset(3, 3), // Posición de la sombra
                    color: Colors.black.withOpacity(0.3), // Color y opacidad de la sombra
                    blurRadius: 5, // Difuminado de la sombra
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Alineación central
            ),
          ),
          // Imágenes con texto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'En caso de tener alguna duda, sugerencia o prblemática, puedes ponerte en contacto con nosotros a través de los siguientes medios.',
                  style: TextStyle(
                    fontSize: 15, // Tamaño de fuente
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15),
                _buildImageWithText(
                  'assets/yo.png', 
                  'Kevin Omar Arredondo Arenas',
                ),
                const SizedBox(height: 10),
                Text(
                  'Facebook: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- Kevin Arenas ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  'Correo: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- ko.arredondoarenas@ugto.mx ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ), // Espaciado entre las filas
                const SizedBox(height: 40),
                _buildImageWithText(
                  'assets/edgar.png',
                  'José Edgar Rodríguez Vázquez',
                ),
                const SizedBox(height: 10,),
                Text(
                  'Facebook: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- José Edgar Rodríguez Vázquez ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  'Correo: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- je.rodriguezvazquez@ugto.mx ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
                _buildImageWithText(
                  'assets/rodo.png',
                  'Juan Rodolfo Mosqueda Lozano'
                ),
                const SizedBox(height: 10,),
                Text(
                  'Facebook: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- Rodolfo Mosqueda ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  'Correo: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  '- jr.mosquedalozano@ugto.mx ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
                Text(
                  'Gracias!!! <3',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal.shade300, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                Text(
                  'Ayúdanos a mejorar para brindarte la mejor atención y el servicio posible, para nosotros tu retroalimentación es muy importante.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10,),
                Text(
                  '                                         Atte. El equipo de Healthy Feet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal.shade100, // Tamaño de fuente
                    height: 1,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithText(String imagePath, String text) {
    return Row(
      children: [
        // Imagen
        ClipRRect(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        child: Image.asset(
          imagePath,
          width: 130,
          height: 130,
          fit: BoxFit.contain,
        ),
      ),
        const SizedBox(width: 1), // Espaciado entre imagen y texto
        // Texto
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.displayMedium!.copyWith(
      fontSize: 26.0, //Tamaño fuente
      color: theme.colorScheme.primaryContainer, //Color fuente
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}