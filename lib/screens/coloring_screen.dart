import 'package:flutter/material.dart';

class ColoringPage {
  final String id;
  final String name;
  final String category;

  const ColoringPage({
    required this.id,
    required this.name,
    required this.category,
  });
}

const coloringPages = [
  ColoringPage(
    id: 'dog_001',
    name: 'Happy Dog',
    category: 'Animals',
  ),
  ColoringPage(
    id: 'lion_001',
    name: 'Happy Lion',
    category: 'Animals',
  ),
  ColoringPage(
    id: 'cat_001',
    name: 'Happy Cat',
    category: 'Animals',
  ),
  ColoringPage(
    id: 'rabbit_001',
    name: 'Happy Rabbit',
    category: 'Animals',
  ),

  ColoringPage(
    id: 'dinosaur_001',
    name: 'Happy T-Rex',
    category: 'Dinosaurs',
  ),
  ColoringPage(
    id: 'dinosaur_002',
    name: 'Friendly Triceratops',
    category: 'Dinosaurs',
  ),
  ColoringPage(
    id: 'dinosaur_003',
    name: 'Cute Stegosaurus',
    category: 'Dinosaurs',
  ),
  ColoringPage(
    id: 'dinosaur_004',
    name: 'Baby Brachiosaurus',
    category: 'Dinosaurs',
  ),

  ColoringPage(
    id: 'vehicle_001',
    name: 'Race Car',
    category: 'Vehicles',
  ),
  ColoringPage(
    id: 'vehicle_002',
    name: 'Fire Truck',
    category: 'Vehicles',
  ),
  ColoringPage(
    id: 'vehicle_003',
    name: 'School Bus',
    category: 'Vehicles',
  ),
  ColoringPage(
    id: 'vehicle_004',
    name: 'Airplane',
    category: 'Vehicles',
  ),

  ColoringPage(
    id: 'space_001',
    name: 'Rocket',
    category: 'Space',
  ),
  ColoringPage(
    id: 'space_002',
    name: 'Astronaut',
    category: 'Space',
  ),
  ColoringPage(
    id: 'space_003',
    name: 'Planet',
    category: 'Space',
  ),
  ColoringPage(
    id: 'space_004',
    name: 'UFO',
    category: 'Space',
  ),
];

enum ColoringPart {
  head,
  leftEar,
  rightEar,
  body,
  leftLeg,
  rightLeg,
  tail,
  leftWing,
  rightWing,
  wheel,
  window,
  roof,
  flame,
  spike,
  horn,
  belly,
  shell,
  fin,
  arm,
  leftArm,
  jaw,
  helmet,
  visor,
  planet,
  ring,
  rocketBody,
  rocketWindow,
  carBody,
  carWindow,
  truckBody,
  busBody,
  airplaneBody,
  airplaneWing,
  ufoBody,
  ufoGlass,
}

class ColoringScreen extends StatefulWidget {
  final ColoringPage page;

  const ColoringScreen({
    super.key,
    required this.page,
  });

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  Color selectedColor = Colors.red;

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  final Map<ColoringPart, Color> partColors = {};

  final List<Map<ColoringPart, Color>> history = [];

  @override
  void initState() {
    super.initState();
    _resetColorsWithoutHistory();
  }

  void _saveHistory() {
    history.add(Map<ColoringPart, Color>.from(partColors));

    if (history.length > 30) {
      history.removeAt(0);
    }
  }

  void _colorPart(ColoringPart part) {
    _saveHistory();

    setState(() {
      partColors[part] = selectedColor;
    });
  }

  void resetColors() {
    _saveHistory();

    setState(() {
      partColors.clear();
    });
  }

  void colorAgain() {
    setState(() {
      partColors.clear();
      history.clear();
    });
  }

  void undoLastAction() {
    if (history.isEmpty) return;

    setState(() {
      final previousState = history.removeLast();

      partColors
        ..clear()
        ..addAll(previousState);
    });
  }

  void _resetColorsWithoutHistory() {
    partColors.clear();
    history.clear();
  }

  String get _instructionText {
    switch (widget.page.id) {
      case 'dog_001':
        return 'Tap a part of the dog to color it!';
      case 'lion_001':
        return 'Tap a part of the lion to color it!';
      case 'cat_001':
        return 'Tap a part of the cat to color it!';
      case 'rabbit_001':
        return 'Tap a part of the rabbit to color it!';

      case 'dinosaur_001':
        return 'Tap a part of the T-Rex to color it!';
      case 'dinosaur_002':
        return 'Tap a part of the triceratops to color it!';
      case 'dinosaur_003':
        return 'Tap a part of the stegosaurus to color it!';
      case 'dinosaur_004':
        return 'Tap a part of the brachiosaurus to color it!';

      case 'vehicle_001':
        return 'Tap a part of the race car to color it!';
      case 'vehicle_002':
        return 'Tap a part of the fire truck to color it!';
      case 'vehicle_003':
        return 'Tap a part of the school bus to color it!';
      case 'vehicle_004':
        return 'Tap a part of the airplane to color it!';

      case 'space_001':
        return 'Tap a part of the rocket to color it!';
      case 'space_002':
        return 'Tap a part of the astronaut to color it!';
      case 'space_003':
        return 'Tap a part of the planet to color it!';
      case 'space_004':
        return 'Tap a part of the UFO to color it!';
      default:
        return 'Tap a part to color it!';
    }
  }

  Color _partColor(ColoringPart part) {
    return partColors[part] ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F3),
      appBar: AppBar(
        title: Text(
          widget.page.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Text(
            _instructionText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Center(
              child: GestureDetector(
                onTapUp: _handleTap,
                child: CustomPaint(
                  size: const Size(330, 330),
                  painter: _ColoringPainter(
                    pageId: widget.page.id,
                    partColors: partColors,
                  ),
                ),
              ),
            ),
          ),

          const Text(
            'Choose a color',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E4A59),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors.map((color) {
                final isSelected = selectedColor == color;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: isSelected ? 54 : 46,
                    height: isSelected ? 54 : 46,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.white,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        history.isEmpty ? null : undoLastAction,
                    icon: const Icon(Icons.undo),
                    label: const Text('Undo'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: partColors.isEmpty
                        ? null
                        : resetColors,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: colorAgain,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Color Again',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      backgroundColor: const Color(0xFF66BB6A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(TapUpDetails details) {
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;

    final part = _getPartAt(
      x,
      y,
      widget.page.id,
    );

    if (part != null) {
      _colorPart(part);
    }
  }

  ColoringPart? _getPartAt(
    double x,
    double y,
    String pageId,
  ) {
    switch (pageId) {
      case 'dog_001':
        return _getDogPartAt(x, y);

      case 'lion_001':
        return _getLionPartAt(x, y);

      case 'cat_001':
        return _getCatPartAt(x, y);

      case 'rabbit_001':
        return _getRabbitPartAt(x, y);

      case 'dinosaur_001':
        return _getTRexPartAt(x, y);

      case 'dinosaur_002':
        return _getTriceratopsPartAt(x, y);

      case 'dinosaur_003':
        return _getStegosaurusPartAt(x, y);

      case 'dinosaur_004':
        return _getBrachiosaurusPartAt(x, y);

      case 'vehicle_001':
        return _getRaceCarPartAt(x, y);

      case 'vehicle_002':
        return _getFireTruckPartAt(x, y);

      case 'vehicle_003':
        return _getSchoolBusPartAt(x, y);

      case 'vehicle_004':
        return _getAirplanePartAt(x, y);

      case 'space_001':
        return _getRocketPartAt(x, y);

      case 'space_002':
        return _getAstronautPartAt(x, y);

      case 'space_003':
        return _getPlanetPartAt(x, y);

      case 'space_004':
        return _getUfoPartAt(x, y);

      default:
        return null;
    }
  }

  ColoringPart? _getDogPartAt(double x, double y) {
  // =========================================================
  // DOG HIT TEST
  // IMPORTANT:
  // The head is checked BEFORE the ears because the ears
  // visually sit behind the head.
  // =========================================================

  // ---------------------------------------------------------
  // 1. HEAD
  // ---------------------------------------------------------
  //
  // The actual painted head is:
  // Rect.fromLTWH(105, 72, 120, 112)
  //
  // We prioritize it so taps on the visible face always
  // color the head instead of accidentally coloring an ear.
  //
  if (x >= 105 && x <= 225 && y >= 72 && y <= 184) {
    return ColoringPart.head;
  }

  // ---------------------------------------------------------
  // 2. LEFT EAR
  // ---------------------------------------------------------
  //
  // Only the visible part outside the head should respond
  // as the left ear.
  //
  if (x >= 68 && x < 105 && y >= 55 && y <= 148) {
    return ColoringPart.leftEar;
  }

  // ---------------------------------------------------------
  // 3. RIGHT EAR
  // ---------------------------------------------------------
  //
  // Only the visible part outside the head should respond
  // as the right ear.
  //
  if (x > 225 && x <= 262 && y >= 55 && y <= 148) {
    return ColoringPart.rightEar;
  }

  // ---------------------------------------------------------
  // 4. TAIL
  // ---------------------------------------------------------
  //
  // Tail is painted behind the body.
  // Therefore the body must win where the two areas overlap.
  //
  if (x > 230 && x <= 300 && y >= 180 && y <= 255) {
    return ColoringPart.tail;
  }

  // ---------------------------------------------------------
  // 5. BODY
  // ---------------------------------------------------------
  //
  // Actual body:
  // Rect.fromLTWH(100, 175, 130, 105)
  //
  if (x >= 100 && x <= 230 && y >= 175 && y <= 280) {
    return ColoringPart.body;
  }

  // ---------------------------------------------------------
  // 6. LEFT LEG
  // ---------------------------------------------------------
  //
  if (x >= 92 && x <= 144 && y >= 265 && y <= 327) {
    return ColoringPart.leftLeg;
  }

  // ---------------------------------------------------------
  // 7. RIGHT LEG
  // ---------------------------------------------------------
  //
  if (x >= 186 && x <= 238 && y >= 265 && y <= 327) {
    return ColoringPart.rightLeg;
  }

  return null;
}

  ColoringPart? _getLionPartAt(double x, double y) {
  // =========================================================
  // LION HEAD
  // Actual painted head:
  // center (165,125), radius 80
  // =========================================================
  final headDistance = Offset(x - 165, y - 125).distance;

  if (headDistance <= 80) {
    return ColoringPart.head;
  }

  // =========================================================
  // LION BODY
  // Actual painted body:
  // Rect.fromLTWH(105,180,120,100)
  // =========================================================
  if (x >= 105 &&
      x <= 225 &&
      y >= 180 &&
      y <= 280) {
    return ColoringPart.body;
  }

  // =========================================================
  // LEFT LEG
  // =========================================================
  if (x >= 90 &&
      x <= 145 &&
      y >= 260 &&
      y <= 325) {
    return ColoringPart.leftLeg;
  }

  // =========================================================
  // RIGHT LEG
  // =========================================================
  if (x >= 185 &&
      x <= 240 &&
      y >= 260 &&
      y <= 325) {
    return ColoringPart.rightLeg;
  }

  // =========================================================
  // TAIL
  // =========================================================
  if (x >= 215 &&
      x <= 285 &&
      y >= 180 &&
      y <= 265) {
    return ColoringPart.tail;
  }

  return null;
}

  ColoringPart? _getCatPartAt(double x, double y) {
    if (x > 95 && x < 235 && y > 75 && y < 190) {
      return ColoringPart.head;
    }

    if (x > 85 && x < 130 && y > 45 && y < 115) {
      return ColoringPart.leftEar;
    }

    if (x > 200 && x < 245 && y > 45 && y < 115) {
      return ColoringPart.rightEar;
    }

    if (x > 100 && x < 230 && y > 175 && y < 275) {
      return ColoringPart.body;
    }

    if (x > 90 && x < 140 && y > 255 && y < 315) {
      return ColoringPart.leftLeg;
    }

    if (x > 190 && x < 240 && y > 255 && y < 315) {
      return ColoringPart.rightLeg;
    }

    if (x > 215 && x < 290 && y > 180 && y < 245) {
      return ColoringPart.tail;
    }

    return null;
  }

  ColoringPart? _getRabbitPartAt(double x, double y) {
    // Ears are checked BEFORE the head so the ears are independently
    // colorable.
    if (x > 78 && x < 135 && y > 25 && y < 130) {
      return ColoringPart.leftEar;
    }

    if (x > 195 && x < 252 && y > 25 && y < 130) {
      return ColoringPart.rightEar;
    }

    if (x > 95 && x < 235 && y > 95 && y < 195) {
      return ColoringPart.head;
    }

    if (x > 100 && x < 230 && y > 180 && y < 280) {
      return ColoringPart.body;
    }

    if (x > 90 && x < 140 && y > 260 && y < 320) {
      return ColoringPart.leftLeg;
    }

    if (x > 190 && x < 240 && y > 260 && y < 320) {
      return ColoringPart.rightLeg;
    }

    if (x > 215 && x < 285 && y > 185 && y < 245) {
      return ColoringPart.tail;
    }

    return null;
  }

  ColoringPart? _getTRexPartAt(double x, double y) {
    if (x > 190 && x < 285 && y > 70 && y < 180) {
      return ColoringPart.head;
    }

    if (x > 85 && x < 220 && y > 125 && y < 260) {
      return ColoringPart.body;
    }

    if (x > 80 && x < 140 && y > 235 && y < 320) {
      return ColoringPart.leftLeg;
    }

    if (x > 165 && x < 225 && y > 235 && y < 320) {
      return ColoringPart.rightLeg;
    }

    if (x > 55 && x < 120 && y > 145 && y < 220) {
      return ColoringPart.tail;
    }

    if (x > 205 && x < 275 && y > 45 && y < 100) {
      return ColoringPart.jaw;
    }

    return null;
  }

  ColoringPart? _getTriceratopsPartAt(double x, double y) {
    if (x > 190 && x < 285 && y > 95 && y < 190) {
      return ColoringPart.head;
    }

    if (x > 100 && x < 225 && y > 150 && y < 270) {
      return ColoringPart.body;
    }

    if (x > 90 && x < 140 && y > 255 && y < 320) {
      return ColoringPart.leftLeg;
    }

    if (x > 175 && x < 225 && y > 255 && y < 320) {
      return ColoringPart.rightLeg;
    }

    if (x > 55 && x < 125 && y > 160 && y < 225) {
      return ColoringPart.tail;
    }

    if (x > 220 && x < 280 && y > 55 && y < 125) {
      return ColoringPart.horn;
    }

    return null;
  }

  ColoringPart? _getStegosaurusPartAt(double x, double y) {
    if (x > 195 && x < 285 && y > 85 && y < 175) {
      return ColoringPart.head;
    }

    if (x > 85 && x < 225 && y > 145 && y < 270) {
      return ColoringPart.body;
    }

    if (x > 80 && x < 140 && y > 255 && y < 320) {
      return ColoringPart.leftLeg;
    }

    if (x > 175 && x < 230 && y > 255 && y < 320) {
      return ColoringPart.rightLeg;
    }

    if (x > 45 && x < 115 && y > 150 && y < 230) {
      return ColoringPart.tail;
    }

    if (x > 80 && x < 225 && y > 75 && y < 170) {
      return ColoringPart.spike;
    }

    return null;
  }

  ColoringPart? _getBrachiosaurusPartAt(double x, double y) {
    if (x > 210 && x < 290 && y > 35 && y < 150) {
      return ColoringPart.head;
    }

    if (x > 90 && x < 235 && y > 145 && y < 250) {
      return ColoringPart.body;
    }

    if (x > 75 && x < 125 && y > 230 && y < 320) {
      return ColoringPart.leftLeg;
    }

    if (x > 175 && x < 225 && y > 230 && y < 320) {
      return ColoringPart.rightLeg;
    }

    if (x > 45 && x < 115 && y > 120 && y < 210) {
      return ColoringPart.tail;
    }

    return null;
  }

  ColoringPart? _getRaceCarPartAt(double x, double y) {
    if (x > 65 && x < 270 && y > 145 && y < 245) {
      return ColoringPart.carBody;
    }

    if (x > 115 && x < 215 && y > 95 && y < 170) {
      return ColoringPart.roof;
    }

    if (x > 120 && x < 180 && y > 105 && y < 155) {
      return ColoringPart.carWindow;
    }

    if (x > 55 && x < 115 && y > 220 && y < 285) {
      return ColoringPart.wheel;
    }

    if (x > 205 && x < 265 && y > 220 && y < 285) {
      return ColoringPart.wheel;
    }

    return null;
  }

  ColoringPart? _getFireTruckPartAt(double x, double y) {
    if (x > 75 && x < 260 && y > 130 && y < 250) {
      return ColoringPart.truckBody;
    }

    if (x > 175 && x < 250 && y > 80 && y < 150) {
      return ColoringPart.window;
    }

    if (x > 65 && x < 125 && y > 220 && y < 285) {
      return ColoringPart.wheel;
    }

    if (x > 205 && x < 265 && y > 220 && y < 285) {
      return ColoringPart.wheel;
    }

    return null;
  }

  ColoringPart? _getSchoolBusPartAt(double x, double y) {
    if (x > 55 && x < 275 && y > 120 && y < 255) {
      return ColoringPart.busBody;
    }

    if (x > 75 && x < 255 && y > 90 && y < 160) {
      return ColoringPart.window;
    }

    if (x > 55 && x < 115 && y > 225 && y < 290) {
      return ColoringPart.wheel;
    }

    if (x > 205 && x < 265 && y > 225 && y < 290) {
      return ColoringPart.wheel;
    }

    return null;
  }

  ColoringPart? _getAirplanePartAt(double x, double y) {
    if (x > 80 && x < 260 && y > 130 && y < 210) {
      return ColoringPart.airplaneBody;
    }

    if (x > 90 && x < 240 && y > 90 && y < 175) {
      return ColoringPart.airplaneWing;
    }

    if (x > 100 && x < 230 && y > 145 && y < 195) {
      return ColoringPart.window;
    }

    return null;
  }

  ColoringPart? _getRocketPartAt(double x, double y) {
    if (x > 105 && x < 225 && y > 70 && y < 270) {
      return ColoringPart.rocketBody;
    }

    if (x > 130 && x < 200 && y > 125 && y < 195) {
      return ColoringPart.rocketWindow;
    }

    if (x > 115 && x < 215 && y > 245 && y < 320) {
      return ColoringPart.flame;
    }

    return null;
  }

  ColoringPart? _getAstronautPartAt(double x, double y) {
    if (x > 105 && x < 225 && y > 55 && y < 150) {
      return ColoringPart.head;
    }

    if (x > 100 && x < 230 && y > 140 && y < 255) {
      return ColoringPart.body;
    }

    if (x > 75 && x < 135 && y > 170 && y < 245) {
      return ColoringPart.leftArm;
    }

    if (x > 195 && x < 255 && y > 170 && y < 245) {
      return ColoringPart.rightWing;
    }

    return null;
  }

  ColoringPart? _getPlanetPartAt(double x, double y) {
    if (x > 70 && x < 260 && y > 70 && y < 270) {
      return ColoringPart.planet;
    }

    if (x > 40 && x < 290 && y > 125 && y < 205) {
      return ColoringPart.ring;
    }

    return null;
  }

  ColoringPart? _getUfoPartAt(double x, double y) {
    if (x > 60 && x < 270 && y > 150 && y < 240) {
      return ColoringPart.ufoBody;
    }

    if (x > 120 && x < 210 && y > 105 && y < 175) {
      return ColoringPart.ufoGlass;
    }

    return null;
  }
}

class _ColoringPainter extends CustomPainter {
  final String pageId;
  final Map<ColoringPart, Color> partColors;

  _ColoringPainter({
    required this.pageId,
    required this.partColors,
  });

  Color _color(ColoringPart part) {
    return partColors[part] ?? Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (pageId) {
      case 'dog_001':
        _paintDog(canvas);
        break;
      case 'lion_001':
        _paintLion(canvas);
        break;
      case 'cat_001':
        _paintCat(canvas);
        break;
      case 'rabbit_001':
        _paintRabbit(canvas);
        break;
      case 'dinosaur_001':
        _paintTRex(canvas);
        break;
      case 'dinosaur_002':
        _paintTriceratops(canvas);
        break;
      case 'dinosaur_003':
        _paintStegosaurus(canvas);
        break;
      case 'dinosaur_004':
        _paintBrachiosaurus(canvas);
        break;
      case 'vehicle_001':
        _paintRaceCar(canvas);
        break;
      case 'vehicle_002':
        _paintFireTruck(canvas);
        break;
      case 'vehicle_003':
        _paintSchoolBus(canvas);
        break;
      case 'vehicle_004':
        _paintAirplane(canvas);
        break;
      case 'space_001':
        _paintRocket(canvas);
        break;
      case 'space_002':
        _paintAstronaut(canvas);
        break;
      case 'space_003':
        _paintPlanet(canvas);
        break;
      case 'space_004':
        _paintUfo(canvas);
        break;
    }
  }

  Paint _fill(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  Paint _outline() {
    return Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _paintDog(Canvas canvas) {
  final outline = _outline();

  // =========================
  // 1. TAIL - BEHIND BODY
  // =========================

  final tail = Path()
    ..moveTo(225, 205)
    ..quadraticBezierTo(260, 175, 282, 190)
    ..quadraticBezierTo(300, 208, 286, 238)
    ..quadraticBezierTo(275, 255, 255, 245)
    ..quadraticBezierTo(242, 232, 230, 225)
    ..close();

  canvas.drawPath(
    tail,
    _fill(_color(ColoringPart.tail)),
  );

  canvas.drawPath(tail, outline);

  // =========================
  // 2. LEGS
  // =========================

  final leftLeg = RRect.fromRectAndRadius(
    const Rect.fromLTWH(92, 265, 52, 62),
    const Radius.circular(20),
  );

  final rightLeg = RRect.fromRectAndRadius(
    const Rect.fromLTWH(186, 265, 52, 62),
    const Radius.circular(20),
  );

  canvas.drawRRect(
    leftLeg,
    _fill(_color(ColoringPart.leftLeg)),
  );

  canvas.drawRRect(
    rightLeg,
    _fill(_color(ColoringPart.rightLeg)),
  );

  canvas.drawRRect(leftLeg, outline);
  canvas.drawRRect(rightLeg, outline);

  // =========================
  // 3. BODY
  // =========================

  final body = RRect.fromRectAndRadius(
    const Rect.fromLTWH(100, 175, 130, 105),
    const Radius.circular(38),
  );

  canvas.drawRRect(
    body,
    _fill(_color(ColoringPart.body)),
  );

  canvas.drawRRect(body, outline);

  // =========================
  // 4. EARS - BEHIND HEAD
  // =========================

  final leftEar = Path()
    ..moveTo(112, 105)
    ..quadraticBezierTo(92, 78, 78, 65)
    ..quadraticBezierTo(68, 58, 68, 75)
    ..lineTo(72, 125)
    ..quadraticBezierTo(74, 145, 90, 148)
    ..quadraticBezierTo(106, 150, 116, 132)
    ..close();

  final rightEar = Path()
    ..moveTo(218, 105)
    ..quadraticBezierTo(238, 78, 252, 65)
    ..quadraticBezierTo(262, 58, 262, 75)
    ..lineTo(258, 125)
    ..quadraticBezierTo(256, 145, 240, 148)
    ..quadraticBezierTo(224, 150, 214, 132)
    ..close();

  canvas.drawPath(
    leftEar,
    _fill(_color(ColoringPart.leftEar)),
  );

  canvas.drawPath(
    rightEar,
    _fill(_color(ColoringPart.rightEar)),
  );

  canvas.drawPath(leftEar, outline);
  canvas.drawPath(rightEar, outline);

  // =========================
  // 5. HEAD
  // =========================

  final head = RRect.fromRectAndRadius(
    const Rect.fromLTWH(105, 72, 120, 112),
    const Radius.circular(48),
  );

  canvas.drawRRect(
    head,
    _fill(_color(ColoringPart.head)),
  );

  canvas.drawRRect(head, outline);

  // =========================
  // 6. FACE
  // =========================

  // Eyes
  canvas.drawCircle(
    const Offset(145, 115),
    7,
    _fill(Colors.black),
  );

  canvas.drawCircle(
    const Offset(185, 115),
    7,
    _fill(Colors.black),
  );

  // Nose
  canvas.drawCircle(
    const Offset(165, 140),
    9,
    _fill(Colors.black),
  );

  // Mouth
  final mouth = Path()
    ..moveTo(165, 149)
    ..quadraticBezierTo(165, 160, 153, 162)
    ..moveTo(165, 149)
    ..quadraticBezierTo(165, 160, 177, 162);

  canvas.drawPath(mouth, outline);

  // Small cheeks
  canvas.drawCircle(
    const Offset(128, 145),
    4,
    _fill(Colors.black12),
  );

  canvas.drawCircle(
    const Offset(202, 145),
    4,
    _fill(Colors.black12),
  );
}

  void _paintLion(Canvas canvas) {
    final outline = _outline();

    canvas.drawCircle(
      const Offset(165, 125),
      80,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 180, 120, 100),
        const Radius.circular(40),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 260, 55, 65),
        const Radius.circular(20),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(185, 260, 55, 65),
        const Radius.circular(20),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(215, 210)
      ..quadraticBezierTo(285, 180, 275, 245)
      ..quadraticBezierTo(260, 265, 230, 235)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    canvas.drawCircle(const Offset(140, 120), 8, _fill(Colors.black));
    canvas.drawCircle(const Offset(190, 120), 8, _fill(Colors.black));

    canvas.drawCircle(
      const Offset(165, 145),
      12,
      _fill(Colors.black),
    );

    canvas.drawPath(
      Path()
        ..moveTo(145, 160)
        ..quadraticBezierTo(165, 175, 185, 160),
      outline,
    );

    _drawLionOutlines(canvas, outline);
  }

  void _drawLionOutlines(Canvas canvas, Paint outline) {
  // HEAD
  canvas.drawCircle(
    const Offset(165, 125),
    80,
    outline,
  );

  // BODY
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(105, 180, 120, 100),
      const Radius.circular(40),
    ),
    outline,
  );

  // LEFT LEG
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(90, 260, 55, 65),
      const Radius.circular(20),
    ),
    outline,
  );

  // RIGHT LEG
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(185, 260, 55, 65),
      const Radius.circular(20),
    ),
    outline,
  );

  // TAIL
  final tail = Path()
    ..moveTo(215, 210)
    ..quadraticBezierTo(285, 180, 275, 245)
    ..quadraticBezierTo(260, 265, 230, 235)
    ..close();

  canvas.drawPath(
    tail,
    outline,
  );
}

  void _paintCat(Canvas canvas) {
    final outline = _outline();

    final head = Path()
      ..moveTo(95, 145)
      ..lineTo(110, 65)
      ..lineTo(145, 95)
      ..quadraticBezierTo(165, 85, 185, 95)
      ..lineTo(220, 65)
      ..lineTo(235, 145)
      ..quadraticBezierTo(230, 190, 165, 195)
      ..quadraticBezierTo(100, 190, 95, 145)
      ..close();

    canvas.drawPath(
      head,
      _fill(_color(ColoringPart.head)),
    );

    final leftEar = Path()
      ..moveTo(95, 145)
      ..lineTo(110, 65)
      ..lineTo(145, 95)
      ..close();

    final rightEar = Path()
      ..moveTo(185, 95)
      ..lineTo(220, 65)
      ..lineTo(235, 145)
      ..close();

    canvas.drawPath(
      leftEar,
      _fill(_color(ColoringPart.leftEar)),
    );

    canvas.drawPath(
      rightEar,
      _fill(_color(ColoringPart.rightEar)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(100, 180, 130, 100),
        const Radius.circular(40),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 260, 50, 65),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(190, 260, 50, 65),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(225, 210)
      ..quadraticBezierTo(290, 170, 280, 245)
      ..quadraticBezierTo(260, 265, 235, 235)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    canvas.drawCircle(const Offset(140, 125), 7, _fill(Colors.black));
    canvas.drawCircle(const Offset(190, 125), 7, _fill(Colors.black));

    canvas.drawCircle(
      const Offset(165, 150),
      8,
      _fill(Colors.pink),
    );

    _drawCatOutlines(canvas, outline);
  }

  void _drawCatOutlines(Canvas canvas, Paint outline) {
    final head = Path()
      ..moveTo(95, 145)
      ..lineTo(110, 65)
      ..lineTo(145, 95)
      ..quadraticBezierTo(165, 85, 185, 95)
      ..lineTo(220, 65)
      ..lineTo(235, 145)
      ..quadraticBezierTo(230, 190, 165, 195)
      ..quadraticBezierTo(100, 190, 95, 145)
      ..close();

    canvas.drawPath(head, outline);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(100, 180, 130, 100),
        const Radius.circular(40),
      ),
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 260, 50, 65),
        const Radius.circular(18),
      ),
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(190, 260, 50, 65),
        const Radius.circular(18),
      ),
      outline,
    );
  }

  void _paintRabbit(Canvas canvas) {
    final outline = _outline();

    final leftEar = RRect.fromRectAndRadius(
      const Rect.fromLTWH(80, 25, 55, 110),
      const Radius.circular(25),
    );

    final rightEar = RRect.fromRectAndRadius(
      const Rect.fromLTWH(195, 25, 55, 110),
      const Radius.circular(25),
    );

    canvas.drawRRect(
      leftEar,
      _fill(_color(ColoringPart.leftEar)),
    );

    canvas.drawRRect(
      rightEar,
      _fill(_color(ColoringPart.rightEar)),
    );

    canvas.drawCircle(
      const Offset(165, 135),
      65,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(100, 185, 130, 100),
        const Radius.circular(45),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 265, 50, 60),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(190, 265, 50, 60),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    canvas.drawCircle(
      const Offset(270, 225),
      25,
      _fill(_color(ColoringPart.tail)),
    );

    canvas.drawCircle(
      const Offset(140, 125),
      7,
      _fill(Colors.black),
    );

    canvas.drawCircle(
      const Offset(190, 125),
      7,
      _fill(Colors.black),
    );

    canvas.drawCircle(
      const Offset(165, 150),
      8,
      _fill(Colors.pink),
    );

    canvas.drawCircle(
      const Offset(165, 175),
      5,
      _fill(Colors.black12),
    );

    _drawRabbitOutlines(canvas, outline);
  }

  void _drawRabbitOutlines(Canvas canvas, Paint outline) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 25, 55, 110),
        const Radius.circular(25),
      ),
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(195, 25, 55, 110),
        const Radius.circular(25),
      ),
      outline,
    );

    canvas.drawCircle(
      const Offset(165, 135),
      65,
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(100, 185, 130, 100),
        const Radius.circular(45),
      ),
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 265, 50, 60),
        const Radius.circular(18),
      ),
      outline,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(190, 265, 50, 60),
        const Radius.circular(18),
      ),
      outline,
    );

    canvas.drawCircle(
      const Offset(270, 225),
      25,
      outline,
    );
  }

  void _paintTRex(Canvas canvas) {
    final outline = _outline();

    final body = Path()
      ..moveTo(80, 180)
      ..quadraticBezierTo(110, 120, 180, 145)
      ..quadraticBezierTo(220, 155, 235, 205)
      ..lineTo(215, 250)
      ..lineTo(105, 250)
      ..close();

    canvas.drawPath(body, _fill(_color(ColoringPart.body)));

    canvas.drawCircle(
      const Offset(235, 115),
      55,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 240, 55, 80),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(170, 240, 55, 80),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(100, 180)
      ..quadraticBezierTo(40, 150, 55, 105)
      ..quadraticBezierTo(75, 135, 120, 145)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    final jaw = Path()
      ..moveTo(210, 130)
      ..lineTo(285, 145)
      ..lineTo(225, 170)
      ..close();

    canvas.drawPath(
      jaw,
      _fill(_color(ColoringPart.jaw)),
    );

    _drawSimpleOutline(canvas, body, outline);

    canvas.drawCircle(
      const Offset(250, 105),
      7,
      _fill(Colors.black),
    );
  }

  void _paintTriceratops(Canvas canvas) {
    final outline = _outline();

    canvas.drawCircle(
      const Offset(235, 135),
      55,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(100, 165, 130, 110),
        const Radius.circular(45),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 260, 50, 65),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(180, 260, 50, 65),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(105, 185)
      ..quadraticBezierTo(45, 155, 60, 115)
      ..quadraticBezierTo(80, 145, 120, 155)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    final horn = Path()
      ..moveTo(225, 90)
      ..lineTo(235, 45)
      ..lineTo(250, 92)
      ..close();

    canvas.drawPath(
      horn,
      _fill(_color(ColoringPart.horn)),
    );

    _drawCircleOutline(canvas, const Offset(235, 135), 55, outline);

    canvas.drawCircle(
      const Offset(255, 125),
      7,
      _fill(Colors.black),
    );
  }

  void _paintStegosaurus(Canvas canvas) {
    final outline = _outline();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(85, 145, 140, 115),
        const Radius.circular(55),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawCircle(
      const Offset(235, 125),
      45,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 245, 55, 75),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(175, 245, 55, 75),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(100, 180)
      ..quadraticBezierTo(35, 145, 55, 105)
      ..quadraticBezierTo(80, 140, 120, 150)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    final spikePaint = _fill(_color(ColoringPart.spike));

    for (final offset in const [
      Offset(100, 135),
      Offset(125, 115),
      Offset(150, 105),
      Offset(175, 110),
      Offset(200, 125),
    ]) {
      final spike = Path()
        ..moveTo(offset.dx - 10, offset.dy + 25)
        ..lineTo(offset.dx, offset.dy - 15)
        ..lineTo(offset.dx + 10, offset.dy + 25)
        ..close();

      canvas.drawPath(spike, spikePaint);
      canvas.drawPath(spike, outline);
    }

    _drawSimpleRRectOutline(
      canvas,
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(85, 145, 140, 115),
        const Radius.circular(55),
      ),
      outline,
    );

    _drawCircleOutline(
      canvas,
      const Offset(235, 125),
      45,
      outline,
    );

    canvas.drawCircle(
      const Offset(250, 120),
      6,
      _fill(Colors.black),
    );
  }

  void _paintBrachiosaurus(Canvas canvas) {
    final outline = _outline();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 150, 140, 105),
        const Radius.circular(50),
      ),
      _fill(_color(ColoringPart.body)),
    );

    final neck = Path()
      ..moveTo(190, 170)
      ..quadraticBezierTo(210, 105, 225, 80)
      ..lineTo(250, 90)
      ..quadraticBezierTo(230, 150, 220, 200)
      ..close();

    canvas.drawPath(
      neck,
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawCircle(
      const Offset(250, 70),
      38,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 235, 50, 90),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.leftLeg)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(175, 235, 50, 90),
        const Radius.circular(18),
      ),
      _fill(_color(ColoringPart.rightLeg)),
    );

    final tail = Path()
      ..moveTo(100, 180)
      ..quadraticBezierTo(45, 140, 50, 100)
      ..quadraticBezierTo(75, 135, 120, 150)
      ..close();

    canvas.drawPath(
      tail,
      _fill(_color(ColoringPart.tail)),
    );

    _drawSimpleRRectOutline(
      canvas,
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 150, 140, 105),
        const Radius.circular(50),
      ),
      outline,
    );

    canvas.drawPath(neck, outline);
    _drawCircleOutline(
      canvas,
      const Offset(250, 70),
      38,
      outline,
    );
  }

  void _paintRaceCar(Canvas canvas) {
    final outline = _outline();

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(55, 150, 220, 100),
      const Radius.circular(30),
    );

    canvas.drawRRect(
      body,
      _fill(_color(ColoringPart.carBody)),
    );

    final roof = Path()
      ..moveTo(110, 150)
      ..lineTo(135, 100)
      ..lineTo(205, 100)
      ..lineTo(235, 150)
      ..close();

    canvas.drawPath(
      roof,
      _fill(_color(ColoringPart.roof)),
    );

    final window = Path()
      ..moveTo(140, 110)
      ..lineTo(195, 110)
      ..lineTo(215, 145)
      ..lineTo(125, 145)
      ..close();

    canvas.drawPath(
      window,
      _fill(_color(ColoringPart.carWindow)),
    );

    canvas.drawCircle(
      const Offset(105, 250),
      32,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawCircle(
      const Offset(225, 250),
      32,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawRRect(body, outline);
    canvas.drawPath(roof, outline);
    canvas.drawPath(window, outline);
    canvas.drawCircle(const Offset(105, 250), 32, outline);
    canvas.drawCircle(const Offset(225, 250), 32, outline);
  }

  void _paintFireTruck(Canvas canvas) {
    final outline = _outline();

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(65, 135, 200, 115),
      const Radius.circular(20),
    );

    canvas.drawRRect(
      body,
      _fill(_color(ColoringPart.truckBody)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(175, 85, 80, 65),
        const Radius.circular(15),
      ),
      _fill(_color(ColoringPart.window)),
    );

    canvas.drawCircle(
      const Offset(95, 255),
      30,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawCircle(
      const Offset(225, 255),
      30,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawRRect(body, outline);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(175, 85, 80, 65),
        const Radius.circular(15),
      ),
      outline,
    );

    canvas.drawLine(
      const Offset(100, 120),
      const Offset(180, 65),
      outline,
    );
  }

  void _paintSchoolBus(Canvas canvas) {
    final outline = _outline();

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(50, 120, 230, 135),
      const Radius.circular(20),
    );

    canvas.drawRRect(
      body,
      _fill(_color(ColoringPart.busBody)),
    );

    for (int i = 0; i < 4; i++) {
      final x = 75.0 + i * 45;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 140, 35, 45),
          const Radius.circular(6),
        ),
        _fill(_color(ColoringPart.window)),
      );
    }

    canvas.drawCircle(
      const Offset(100, 265),
      30,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawCircle(
      const Offset(230, 265),
      30,
      _fill(_color(ColoringPart.wheel)),
    );

    canvas.drawRRect(body, outline);
    canvas.drawLine(
      const Offset(55, 210),
      const Offset(275, 210),
      outline,
    );
  }

  void _paintAirplane(Canvas canvas) {
    final outline = _outline();

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(80, 135, 180, 65),
      const Radius.circular(30),
    );

    canvas.drawRRect(
      body,
      _fill(_color(ColoringPart.airplaneBody)),
    );

    final wing = Path()
      ..moveTo(145, 155)
      ..lineTo(100, 85)
      ..lineTo(140, 85)
      ..lineTo(180, 150)
      ..close();

    canvas.drawPath(
      wing,
      _fill(_color(ColoringPart.airplaneWing)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(170, 150, 25, 18),
        const Radius.circular(8),
      ),
      _fill(_color(ColoringPart.window)),
    );

    canvas.drawRRect(body, outline);
    canvas.drawPath(wing, outline);
  }

  void _paintRocket(Canvas canvas) {
    final outline = _outline();

    final body = Path()
      ..moveTo(105, 250)
      ..lineTo(105, 130)
      ..quadraticBezierTo(115, 70, 165, 45)
      ..quadraticBezierTo(215, 70, 225, 130)
      ..lineTo(225, 250)
      ..close();

    canvas.drawPath(
      body,
      _fill(_color(ColoringPart.rocketBody)),
    );

    canvas.drawCircle(
      const Offset(165, 155),
      32,
      _fill(_color(ColoringPart.rocketWindow)),
    );

    final flame = Path()
      ..moveTo(120, 250)
      ..lineTo(150, 250)
      ..lineTo(165, 315)
      ..lineTo(180, 250)
      ..lineTo(210, 250)
      ..close();

    canvas.drawPath(
      flame,
      _fill(_color(ColoringPart.flame)),
    );

    canvas.drawPath(body, outline);
    canvas.drawCircle(const Offset(165, 155), 32, outline);
    canvas.drawPath(flame, outline);
  }

  void _paintAstronaut(Canvas canvas) {
    final outline = _outline();

    canvas.drawCircle(
      const Offset(165, 105),
      50,
      _fill(_color(ColoringPart.head)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 150, 120, 110),
        const Radius.circular(30),
      ),
      _fill(_color(ColoringPart.body)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(65, 170, 55, 75),
        const Radius.circular(25),
      ),
      _fill(_color(ColoringPart.leftArm)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(210, 170, 55, 75),
        const Radius.circular(25),
      ),
      _fill(_color(ColoringPart.rightWing)),
    );

    canvas.drawCircle(
      const Offset(165, 105),
      28,
      _fill(_color(ColoringPart.visor)),
    );

    _drawCircleOutline(
      canvas,
      const Offset(165, 105),
      50,
      outline,
    );

    _drawSimpleRRectOutline(
      canvas,
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 150, 120, 110),
        const Radius.circular(30),
      ),
      outline,
    );

    _drawSimpleRRectOutline(
      canvas,
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(65, 170, 55, 75),
        const Radius.circular(25),
      ),
      outline,
    );

    _drawSimpleRRectOutline(
      canvas,
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(210, 170, 55, 75),
        const Radius.circular(25),
      ),
      outline,
    );

    canvas.drawCircle(
      const Offset(165, 105),
      28,
      outline,
    );
  }

  void _paintPlanet(Canvas canvas) {
    final outline = _outline();

    canvas.drawCircle(
      const Offset(165, 165),
      90,
      _fill(_color(ColoringPart.planet)),
    );

    final ring = Path()
      ..moveTo(55, 165)
      ..quadraticBezierTo(165, 95, 275, 165)
      ..quadraticBezierTo(165, 235, 55, 165)
      ..close();

    canvas.drawPath(
      ring,
      _fill(_color(ColoringPart.ring)),
    );

    canvas.drawCircle(
      const Offset(165, 165),
      90,
      outline,
    );

    canvas.drawPath(ring, outline);
  }

  void _paintUfo(Canvas canvas) {
    final outline = _outline();

    final body = Path()
      ..moveTo(60, 200)
      ..quadraticBezierTo(165, 130, 270, 200)
      ..quadraticBezierTo(165, 265, 60, 200)
      ..close();

    canvas.drawPath(
      body,
      _fill(_color(ColoringPart.ufoBody)),
    );

    final glass = Path()
      ..moveTo(125, 165)
      ..quadraticBezierTo(165, 115, 205, 165)
      ..quadraticBezierTo(165, 190, 125, 165)
      ..close();

    canvas.drawPath(
      glass,
      _fill(_color(ColoringPart.ufoGlass)),
    );

    canvas.drawPath(body, outline);
    canvas.drawPath(glass, outline);
  }

  void _drawSimpleOutline(
    Canvas canvas,
    Path path,
    Paint outline,
  ) {
    canvas.drawPath(path, outline);
  }

  void _drawSimpleRRectOutline(
    Canvas canvas,
    RRect rect,
    Paint outline,
  ) {
    canvas.drawRRect(rect, outline);
  }

  void _drawCircleOutline(
    Canvas canvas,
    Offset center,
    double radius,
    Paint outline,
  ) {
    canvas.drawCircle(center, radius, outline);
  }

  @override
bool shouldRepaint(covariant _ColoringPainter oldDelegate) {
  return true;
}
}