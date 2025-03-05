import 'package:get_storage/get_storage.dart';

class GSKeys {
  static get isAskPermission => "isAskPermissition";
  static get isNotifEnabled => "isNotifEnabled";
  static get isDarkMode => 'isDarkMode';
}

class GSService {
  static final GSService _instance = GSService._internal();

  factory GSService() => _instance;

  GSService._internal();

  late GetStorage _box;

  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  dynamic read(String key, {dynamic defaultValue}) =>
      _box.read(key) ?? defaultValue;

  dynamic write(String key, dynamic value) => _box.write(key, value);

  dynamic remove(String key) => _box.remove(key);

  void clear() {}
}
