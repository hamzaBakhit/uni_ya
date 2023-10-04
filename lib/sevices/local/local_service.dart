import 'package:hive/hive.dart';

class LocalService {
  static LocalService get = LocalService();

  Future<List<String>> rememberUser() async {
    Box box = await Hive.openBox('setting');
    String adminName = await box.get('userEmail', defaultValue: '');
    String adminPassword = await box.get('userPassword', defaultValue: '');
    return [adminName, adminPassword];
  }
  Future<Map<String,dynamic>> getSettings() async {
    Box box = await Hive.openBox('setting');
    bool notification = await box.get('isNotification', defaultValue: true);
    bool theme = await box.get('isLight', defaultValue: true);
    return {
      'isNotification':notification,
      'isLight':theme
    };
  }

  deleteLocalData(List<String> ids) async {
    Box box = await Hive.openBox('setting');
      await box.deleteAll(ids);
   }

  setLocalData(Map<String , dynamic> data)async{
    Box box = await Hive.openBox('setting');
    box.putAll(data);
  }
 Future<dynamic> getLocalData(String key)async{
    Box box = await Hive.openBox('setting');
   return await box.get(key);

  }
}
