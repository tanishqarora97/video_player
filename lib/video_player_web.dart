// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'video_player_platform_interface.dart';

/// A web implementation of the VideoPlayerPlatform of the VideoPlayer plugin.
class VideoPlayerWeb extends VideoPlayerPlatform {
  /// Constructs a VideoPlayerWeb
  VideoPlayerWeb();

  static void registerWith(Registrar registrar) {
    VideoPlayerPlatform.instance = VideoPlayerWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
