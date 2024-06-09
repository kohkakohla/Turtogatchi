import 'package:just_audio/just_audio.dart';

class AudioService extends AudioPlayer {
  // Private constructor
  AudioService._internal();

  // The single instance of AudioService
  static final AudioService _instance = AudioService._internal();

  // The AudioPlayer instance
  final AudioPlayer audioPlayer = AudioPlayer();

  // Factory constructor to return the same instance
  factory AudioService() {
    return _instance;
  }

  @override
  Future<Duration?> setAsset(String asset,
      {Duration? initialPosition, String? package, bool preload = true}) async {
    return audioPlayer.setAsset(asset,
        initialPosition: initialPosition, package: package, preload: preload);
  }

  @override
  Future<void> pause() async {
    await audioPlayer.pause();
  }

  @override
  Future<void> play() async {
    await audioPlayer.play();
  }
}
