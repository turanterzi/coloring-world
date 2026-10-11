import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'sound_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FloodFillColoringScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const FloodFillColoringScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<FloodFillColoringScreen> createState() =>
      _FloodFillColoringScreenState();
}

class _FillAction {
  final int x;
  final int y;
  final Color color;
  const _FillAction(this.x, this.y, this.color);
}

class _TapEffect {
  final int id;
  final Offset position;
  final Color color;
  const _TapEffect(this.id, this.position, this.color);
}

class _FloodFillColoringScreenState extends State<FloodFillColoringScreen> {
  img.Image? _baseImage;
  Uint32List? _fillMask;
  ui.Image? _displayImage;
  bool _loading = true;
  String? _error;

  Color selectedColor = Colors.red;

  final List<Color> colors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Color(0xFFFFCC99), // skin tone - handy for the Mix category characters
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  List<_FillAction> _fillActions = [];
  List<List<_FillAction>> _history = [];

  final List<_TapEffect> _tapEffects = [];
  int _tapEffectIdCounter = 0;

  // True while a save or share is in progress, so the buttons cannot be
  // tapped twice in a row.
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final data = await DefaultAssetBundle.of(context).load(widget.assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final decoded = img.decodePng(bytes);

      if (decoded == null) {
        setState(() {
          _error = 'Failed to decode image.';
          _loading = false;
        });
        return;
      }

      _baseImage = decoded;
      await _loadSavedProgress();
      await _rebuildFillMaskAndImage();

      if (!mounted) return;
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error loading image: $e';
        _loading = false;
      });
    }
  }

  String get _progressKey => 'progress_${widget.assetPath}';
  static const int _maxProgressAgeMs = 7 * 24 * 60 * 60 * 1000; // 7 days

  Future<void> _loadSavedProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_progressKey);
      if (raw == null) return;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = data['savedAt'] as int?;
      if (savedAt == null) return;

      final age = DateTime.now().millisecondsSinceEpoch - savedAt;
      if (age > _maxProgressAgeMs) {
        await prefs.remove(_progressKey); // too old, discard and start fresh
        return;
      }

      final actionsRaw = data['actions'] as List<dynamic>;
      _fillActions = actionsRaw.map((a) {
        final list = a as List<dynamic>;
        return _FillAction(list[0] as int, list[1] as int, Color(list[2] as int));
      }).toList();
    } catch (_) {
      // Corrupted or unreadable save data - ignore and start fresh.
    }
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_fillActions.isEmpty) {
        await prefs.remove(_progressKey);
        return;
      }

      final data = {
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'actions': _fillActions.map((a) => [a.x, a.y, a.color.value]).toList(),
      };
      await prefs.setString(_progressKey, jsonEncode(data));
    } catch (_) {
      // Saving is a nice-to-have; ignore failures silently.
    }
  }

  bool _isBoundary(img.Pixel p) {
    final luminance = (p.r + p.g + p.b) / 3;
    return luminance < 200;
  }

  void _floodFillInto(Uint32List mask, int startX, int startY, Color color) {
    final base = _baseImage!;
    final w = base.width, h = base.height;

    if (startX < 0 || startX >= w || startY < 0 || startY >= h) return;

    final startPixel = base.getPixel(startX, startY);
    if (_isBoundary(startPixel)) return;

    final fillValue = color.value;
    final stack = <int>[startY * w + startX];
    final visited = Uint8List(w * h);

    while (stack.isNotEmpty) {
      final idx = stack.removeLast();
      if (visited[idx] == 1) continue;

      final x = idx % w;
      final y = idx ~/ w;

      var xLeft = x;
      while (xLeft > 0 &&
          visited[y * w + (xLeft - 1)] == 0 &&
          !_isBoundary(base.getPixel(xLeft - 1, y))) {
        xLeft--;
      }

      var xRight = x;
      while (xRight < w - 1 &&
          visited[y * w + (xRight + 1)] == 0 &&
          !_isBoundary(base.getPixel(xRight + 1, y))) {
        xRight++;
      }

      for (var xi = xLeft; xi <= xRight; xi++) {
        final curIdx = y * w + xi;
        visited[curIdx] = 1;
        mask[curIdx] = fillValue;

        if (y > 0) {
          final aboveIdx = (y - 1) * w + xi;
          if (visited[aboveIdx] == 0 && !_isBoundary(base.getPixel(xi, y - 1))) {
            stack.add(aboveIdx);
          }
        }
        if (y < h - 1) {
          final belowIdx = (y + 1) * w + xi;
          if (visited[belowIdx] == 0 && !_isBoundary(base.getPixel(xi, y + 1))) {
            stack.add(belowIdx);
          }
        }
      }
    }
  }

  // Full rebuild: replays every fill action from scratch into a fresh mask.
  // Used for undo/reset/color-again/initial load, where correctness matters
  // more than speed and these happen far less often than individual taps.
  Future<void> _rebuildFillMaskAndImage() async {
    final base = _baseImage!;
    final w = base.width, h = base.height;

    final mask = Uint32List(w * h);
    for (final action in _fillActions) {
      _floodFillInto(mask, action.x, action.y, action.color);
    }

    _fillMask = mask;
    await _composeDisplayImage(mask);
  }

  // Fast path for normal tapping: flood-fills just the new region into the
  // EXISTING mask instead of replaying every previous tap, so coloring stays
  // responsive no matter how many regions have already been filled.
  Future<void> _applyFillAndCompose(_FillAction action) async {
    final base = _baseImage!;
    _fillMask ??= Uint32List(base.width * base.height);

    _floodFillInto(_fillMask!, action.x, action.y, action.color);
    await _composeDisplayImage(_fillMask!);
  }

  Future<void> _composeDisplayImage(Uint32List mask) async {
    final base = _baseImage!;
    final w = base.width, h = base.height;

    final composed = Uint8List(w * h * 4);
    for (var i = 0; i < w * h; i++) {
      final x = i % w;
      final y = i ~/ w;
      final basePixel = base.getPixel(x, y);
      final fillColor = mask[i];

      if (fillColor != 0 && !_isBoundary(basePixel)) {
        final c = Color(fillColor);
        composed[i * 4] = c.red;
        composed[i * 4 + 1] = c.green;
        composed[i * 4 + 2] = c.blue;
        composed[i * 4 + 3] = 255;
      } else {
        composed[i * 4] = basePixel.r.toInt();
        composed[i * 4 + 1] = basePixel.g.toInt();
        composed[i * 4 + 2] = basePixel.b.toInt();
        composed[i * 4 + 3] = basePixel.a.toInt();
      }
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      composed,
      w,
      h,
      ui.PixelFormat.rgba8888,
      (image) => completer.complete(image),
    );
    _displayImage = await completer.future;
  }

  void _saveHistory() {
    _history.add(List<_FillAction>.from(_fillActions));
    if (_history.length > 30) {
      _history.removeAt(0);
    }
  }

  Future<void> _handleTapUp(TapUpDetails details, double displaySize) async {
    if (_baseImage == null) return;

    final scale = _baseImage!.width / displaySize;
    final px = (details.localPosition.dx * scale).round();
    final py = (details.localPosition.dy * scale).round();

    if (px < 0 || px >= _baseImage!.width || py < 0 || py >= _baseImage!.height) {
      return;
    }
    if (_isBoundary(_baseImage!.getPixel(px, py))) return;

    _spawnTapEffect(details.localPosition);

    _saveHistory();
    final action = _FillAction(px, py, selectedColor);
    _fillActions = List<_FillAction>.from(_fillActions)..add(action);

    await _applyFillAndCompose(action);
    await _saveProgress();
    if (!mounted) return;
    setState(() {});
  }

  // Plays a short system click sound and spawns a small sparkle animation
  // at the tap location for a bit of satisfying feedback.
  void _spawnTapEffect(Offset position) {
    final id = _tapEffectIdCounter++;

    setState(() {
      _tapEffects.add(_TapEffect(id, position, selectedColor));
    });

    SoundService.playPop();

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _tapEffects.removeWhere((e) => e.id == id);
      });
    });
  }

  Widget _buildTapEffect(_TapEffect effect) {
    // Use a visible outline color so the sparkle shows up even when the
    // selected color is very light (e.g. white or yellow).
    final bool isLight = effect.color.computeLuminance() > 0.7;
    final Color sparkleColor = isLight ? Colors.black87 : effect.color;

    return Positioned(
      left: effect.position.dx - 22,
      top: effect.position.dy - 22,
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: (1.0 - value).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.4 + value * 1.2,
                child: Icon(Icons.star, color: sparkleColor, size: 44),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _undo() async {
    if (_history.isEmpty) return;

    _fillActions = _history.removeLast();
    await _rebuildFillMaskAndImage();
    await _saveProgress();

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _reset() async {
    if (_fillActions.isEmpty) return;

    _saveHistory();
    _fillActions = [];
    await _rebuildFillMaskAndImage();
    await _saveProgress();

    if (!mounted) return;
    setState(() {});
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // Encodes the current colored picture as PNG bytes.
  Future<Uint8List?> _exportPngBytes() async {
    final image = _displayImage;
    if (image == null) return null;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    return byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  }

  // Saves the finished picture to the device gallery (album "Coloring World").
  Future<void> _saveToGallery() async {
    if (_exporting) return;
    setState(() => _exporting = true);

    try {
      var hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }
      if (!hasAccess) {
        _showMessage('Permission is needed to save pictures to your gallery.');
        return;
      }

      final bytes = await _exportPngBytes();
      if (bytes == null) {
        _showMessage('Could not save the picture. Please try again.');
        return;
      }

      final name = 'coloring_world_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(bytes, name: name, album: 'Coloring World');
      _showMessage('Saved to your gallery!');
    } catch (_) {
      _showMessage('Could not save the picture. Please try again.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  // Opens the system share sheet with the finished picture attached.
  Future<void> _shareImage() async {
    if (_exporting) return;
    setState(() => _exporting = true);

    try {
      final bytes = await _exportPngBytes();
      if (bytes == null) {
        _showMessage('Could not share the picture. Please try again.');
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/coloring_world_share.png');
      await file.writeAsBytes(bytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: 'Look what I colored in Coloring World!',
        ),
      );
    } catch (_) {
      _showMessage('Could not share the picture. Please try again.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  // The colorable canvas. Always sized to fit within whatever space it is
  // given (min of available width/height), so this works unchanged in any
  // layout it's placed in.
  Widget _buildCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Center(
          child: GestureDetector(
            onTapUp: (d) => _handleTapUp(d, size),
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    painter: _ImagePainter(_displayImage!),
                    size: Size(size, size),
                  ),
                  ..._tapEffects.map(_buildTapEffect),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Horizontal palette used in portrait mode, below the canvas.
  // Wrapped so 14 colors flow onto two rows instead of squeezing into one.
  Widget _buildColorPaletteHorizontal() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        ...colors.map((c) => _colorSwatch(c, selectedSize: 40, unselectedSize: 33)),
        _buildColorWheelButton(size: 33),
      ],
    );
  }

  // Vertical palette used in landscape mode, as a left-hand strip.
  // Wrapped to 2 columns so all 8 colors stay visible without cutting off.
  Widget _buildColorPaletteVertical() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        ...colors.map((c) => _colorSwatch(c, selectedSize: 42, unselectedSize: 34)),
        _buildColorWheelButton(size: 34),
      ],
    );
  }

  // The custom "wheel" button at the end of the palette. Tapping it opens a
  // full color picker so kids (or parents) can choose any color, not just
  // the fixed presets.
  Widget _buildColorWheelButton({required double size}) {
    final isCustomActive = !colors.contains(selectedColor);
    return GestureDetector(
      onTap: () {
        SoundService.playClick();
        _showColorPickerDialog();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
              Colors.cyan,
              Colors.blue,
              Colors.purple,
              Colors.red,
            ],
          ),
          border: Border.all(
            color: isCustomActive ? Colors.black : Colors.grey.shade400,
            width: 3,
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }

  Future<void> _showColorPickerDialog() async {
    Color tempColor = selectedColor;

    final picked = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (c) => tempColor = c,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                SoundService.playClick();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                SoundService.playClick();
                Navigator.of(context).pop(tempColor);
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      setState(() => selectedColor = picked);
    }
  }

  Widget _colorSwatch(Color c, {required double selectedSize, required double unselectedSize}) {
    final isSelected = selectedColor == c;
    return GestureDetector(
      onTap: () {
        SoundService.playClick();
        setState(() => selectedColor = c);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isSelected ? selectedSize : unselectedSize,
        height: isSelected ? selectedSize : unselectedSize,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade400,
            width: 3,
          ),
        ),
      ),
    );
  }

  // 2x2 action buttons used in portrait mode, below the palette.
  Widget _buildActionButtonsHorizontal() {
    final undoBtn = ElevatedButton.icon(
      onPressed: _history.isEmpty ? null : () { SoundService.playClick(); _undo(); },
      icon: const Icon(Icons.undo),
      label: const Text('Undo'),
      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
    );
    final resetBtn = ElevatedButton.icon(
      onPressed: _fillActions.isEmpty ? null : () { SoundService.playClick(); _reset(); },
      icon: const Icon(Icons.refresh),
      label: const Text('Reset'),
      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
    );
    final backHomeBtn = ElevatedButton(
      onPressed: () {
        SoundService.playClick();
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        backgroundColor: const Color(0xFF66BB6A),
        foregroundColor: Colors.white,
      ),
      child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
    );

    final saveBtn = ElevatedButton.icon(
      onPressed: _exporting ? null : () { SoundService.playClick(); _saveToGallery(); },
      icon: const Icon(Icons.download),
      label: const Text('Save'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
      ),
    );
    final shareBtn = ElevatedButton.icon(
      onPressed: _exporting ? null : () { SoundService.playClick(); _shareImage(); },
      icon: const Icon(Icons.share),
      label: const Text('Share'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        backgroundColor: const Color(0xFFAB47BC),
        foregroundColor: Colors.white,
      ),
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: saveBtn),
            const SizedBox(width: 10),
            Expanded(child: shareBtn),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: undoBtn),
            const SizedBox(width: 10),
            Expanded(child: resetBtn),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: backHomeBtn),
      ],
    );
  }

  // Vertical action buttons used in landscape mode, as a right-hand strip.
  Widget _buildActionButtonsVertical() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _exporting ? null : () { SoundService.playClick(); _saveToGallery(); },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Save', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: const Color(0xFF42A5F5),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _exporting ? null : () { SoundService.playClick(); _shareImage(); },
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: const Color(0xFFAB47BC),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _history.isEmpty ? null : () { SoundService.playClick(); _undo(); },
            icon: const Icon(Icons.undo, size: 18),
            label: const Text('Undo', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _fillActions.isEmpty ? null : () { SoundService.playClick(); _reset(); },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              SoundService.playClick();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: const Color(0xFF66BB6A),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(child: Text(_error!)),
      );
    }

    if (_loading || _displayImage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F3),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            if (isLandscape) {
              // Left strip: colors. Center: canvas. Right strip: buttons.
              return Row(
                children: [
                  SizedBox(
                    width: 112,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _buildColorPaletteVertical(),
                    ),
                  ),
                  Expanded(child: _buildCanvas()),
                  SizedBox(
                    width: 140,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: _buildActionButtonsVertical(),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(child: _buildCanvas()),
                const SizedBox(height: 4),
                const Text(
                  'Choose a color',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E4A59),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildColorPaletteHorizontal(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                  child: _buildActionButtonsHorizontal(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  _ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: image,
      fit: BoxFit.contain,
    );
  }

  @override
  bool shouldRepaint(covariant _ImagePainter oldDelegate) =>
      oldDelegate.image != image;
}