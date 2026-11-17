import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapAccess {
  static String get accessTokenMap => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
}