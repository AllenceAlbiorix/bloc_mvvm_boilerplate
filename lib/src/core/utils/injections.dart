import 'package:get_it/get_it.dart';
import 'package:ny_times_app/src/core/network/dio_network.dart';
import 'package:ny_times_app/src/core/shared/app_injections.dart';
import 'package:ny_times_app/src/core/utils/log/app_logger.dart';
import 'package:ny_times_app/src/features/articles/ny_times_injections.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> initInjections() async {
  await initSharedPrefsInjections();
  await initAppInjections();
  await initCoreInjections();
  await initArticlesInjections();
}

initSharedPrefsInjections() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await sl.isReady<SharedPreferences>();
}

Future<void> initCoreInjections() async {
  initRootLogger();
  DioNetwork.initDio();
}