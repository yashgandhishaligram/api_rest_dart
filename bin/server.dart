import 'package:api_rest_dart/src/server_config.dart';

Future main() async {
  await LocalServerConfig().setServerConfig();
}


