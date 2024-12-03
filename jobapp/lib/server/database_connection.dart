import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();

  DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }
  Connection? _connection;
  Future<void> initialize() async {
    _connection = await Connection.open(Endpoint(
      // host: 'dpg-csk4vilds78s7396idf0-a.oregon-postgres.render.com',
      // database: 'data_ozxl',
      // username: 'data_ozxl_user',
      // password: '754Vt0vjql1au4Nukoiopk8Jk4GdQdQz',
      host: 'dpg-ct5u5hdumphs738vsdtg-a.oregon-postgres.render.com',
      database: 'name_2a5x',
      username: 'name_2a5x_user',
      password: 'Jblh8O1Af1BbesLy6uRtAl7CZMiLIPHg',
    ));
  }
//name_2a5x_user:Jblh8O1Af1BbesLy6uRtAl7CZMiLIPHg@dpg-ct5u5hdumphs738vsdtg-a.oregon-postgres.render.com/name_2a5x

  Connection? get connection {
    if (_connection == null) {
      throw Exception(
          "Database connection not initialized. Call initialize() first.");
    }
    return _connection;
  }
}
