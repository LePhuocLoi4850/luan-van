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
      host: 'dpg-csk4vilds78s7396idf0-a.oregon-postgres.render.com',
      database: 'data_ozxl',
      username: 'data_ozxl_user',
      password: '754Vt0vjql1au4Nukoiopk8Jk4GdQdQz',
    ));
  }

  Connection? get connection {
    if (_connection == null) {
      throw Exception(
          "Database connection not initialized. Call initialize() first.");
    }
    return _connection;
  }
}
