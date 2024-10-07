import 'package:get_it/get_it.dart';
import 'package:shomare_yab/storage.dart';

final getIt = GetIt.instance;
void appInjector() {
  getIt.registerSingleton<LocalDataBase>(LocalDataBase());
}
