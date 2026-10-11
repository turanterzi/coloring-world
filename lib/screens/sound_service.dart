import 'package:audioplayers/audioplayers.dart';

// A tiny shared sound manager used across every screen so UI taps and the
// coloring canvas each have their own consistent sound effect, without
// every screen needing to create and dispose its own AudioPlayer.
class SoundService {
  SoundService._();

  static final AudioPlayer _popPlayer = AudioPlayer();
  static final AudioPlayer _clickPlayer = AudioPlayer();

  // Played when a region on the coloring canvas is filled.
  static Future<void> playPop() async {
    try {
      await _popPlayer.stop();
      await _popPlayer.play(AssetSource('sounds/pop.mp3'));
    } catch (_) {
      // Sound is a nice-to-have; never let playback issues interrupt the app.
    }
  }

  // Played for general UI button taps (colors, Undo, Reset, category cards,
  // navigation buttons, etc.).
  static Future<void> playClick() async {
    try {
      await _clickPlayer.stop();
      await _clickPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (_) {
      // Sound is a nice-to-have; never let playback issues interrupt the app.
    }
  }
}