library z.flutter.services;

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_dart/convert.dart';
import 'package:z_dart/core.dart'
    show Identifiable, IterableExt, ScopeFunctions;
import 'package:z_dart/io.dart' show Cache, LegacyCache;

export 'package:package_info_plus/package_info_plus.dart';
export 'package:path_provider/path_provider.dart';
export 'package:share_plus/share_plus.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:url_launcher/url_launcher.dart';

part 'src/services/persisted_cache.dart';

part 'src/services/shared_preferences_cache.dart';
