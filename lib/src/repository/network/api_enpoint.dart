import 'package:global_configuration/global_configuration.dart';

class Endpoints {
  Endpoints._();
  static final String baseUrl =
      '${GlobalConfiguration().getValue('api_base_url')}';
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;
}
