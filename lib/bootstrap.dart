import 'package:flutter/widgets.dart';
import 'package:nagaro/core/storage/local_storage_service.dart';

Future<void> bootstrap(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageServiceImpl();
  await storage.init();

  runApp(app);
}
