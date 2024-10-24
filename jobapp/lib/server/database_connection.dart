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
      host: 'dpg-cs0cc4btq21c73eaagdg-a.oregon-postgres.render.com',
      database: 'data_v5kg',
      username: 'data_v5kg_user',
      password: 'fEsjV53yDVhFwS74P5jQJ1exOpjFu72e',
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
