import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final i = GetIt.instance;

Future<void> init() async {
  // * core dependencies
  final sf = await SharedPreferences.getInstance();

  i.registerLazySingleton(() => sf);
  i.registerLazySingleton(() => Dio());
  i.registerLazySingleton(() => PrettyDioLogger());

  // * core service
  i.registerLazySingleton(
    () => DioClient(
      AppConstants.baseUrl,
      i(),
      sharedPreferences: i(),
      prettyDioLogger: i(),
    ),
  );

  // * connectivity service (initialize before registering)
  final cs = ConnectivityService();
  await cs.initialize();
  i.registerLazySingleton(() => cs);

  // * repositories
  i.registerLazySingleton(() => AuthRepo(dc: i(), sf: i()));

  // * blocs
  i.registerFactory(() => ConnectivityBloc(connectivityService: i()));
  i.registerLazySingleton(() => AuthBloc(dc: i(), ar: i()));
}
