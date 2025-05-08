import 'package:envied/envied.dart';

part 'env.g.dart';

// Class for environment variable
@Envied(path: '.env')
abstract class Env {
  Env._();

  @EnviedField(varName: 'API')
  static String api = _Env.api;
}
