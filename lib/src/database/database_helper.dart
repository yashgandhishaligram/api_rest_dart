import 'package:mongo_dart/mongo_dart.dart';

class DatabaseHelper {
  Db? db;
  final String columnName = "name";
  final String columnUserName = "username";
  final String columnPassword = "password";

  void initDb() async {
    Map<String, String> envVars = {};
    var portEnv = envVars['PORT'];
    var PORT =  portEnv == null ? 8080 : int.parse(portEnv);
    String host = '127.0.0.1';
    String port =  '27017';
    db = Db('mongodb://$host:$port/products');
    await db?.open();
  }

 Future<DbCollection?> getDatabase(String databaseName) async {
    var collection =  db?.collection(databaseName);
    return collection;
  }
}