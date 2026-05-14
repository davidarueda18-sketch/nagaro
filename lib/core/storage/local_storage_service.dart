import 'package:hive_ce_flutter/hive_flutter.dart';

abstract interface class LocalStorageService {
  Future<void> init();
  Box<T> getBox<T>(String name);
  Future<void> closeAll();
}

class LocalStorageServiceImpl implements LocalStorageService {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    // Register adapters here as features are added:
    // Hive.registerAdapter(TransactionModelAdapter());
  }

  @override
  Box<T> getBox<T>(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw StateError('Box "$name" is not open. Call openBox first.');
    }
    return Hive.box<T>(name);
  }

  Future<Box<T>> openBox<T>(String name) => Hive.openBox<T>(name);

  @override
  Future<void> closeAll() => Hive.close();
}
