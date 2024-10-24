import 'package:flutter/material.dart';
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
      host: 'dpg-cpt6ibqju9rs73am1vog-a.oregon-postgres.render.com',
      database: 'data_rwqm',
      username: 'data_rwqm_user',
      password: 'Pk7yn1CvfLsbql0ds4pIexeYKHmJcBHo',
    ));
  }

  Connection? get connection {
    if (_connection == null) {
      throw Exception(
          "Database connection not initialized. Call initialize() first.");
    }
    return _connection;
  }

  Future<bool?> checkForExistingEmail(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT email FROM users WHERE email = @email
      '''), parameters: {'email': email});
      return result?.isNotEmpty;
    } catch (e) {
      print('Error checking for existing email: $e');
      return false;
    }
  }

  Future<dynamic> checkForExistingPassword(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT password FROM users WHERE email = @email
      '''), parameters: {'email': email});
      return result;
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<dynamic> checkForExistingRole(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT role FROM users WHERE email = @email
      '''), parameters: {'email': email});
      return result;
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<List<dynamic>> selectDetailUser(String emailU) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT * FROM usersData WHERE email = @email
      '''), parameters: {
        'email': emailU,
      });
      print('Select detail jobs successful');
      final detailUser = result?.toList() ?? [];
      return detailUser;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List> getUserDataByEmail(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT  name, phone, birthday, gender, career, address, description FROM usersdata WHERE email = @email
      '''), parameters: {'email': email});
      return result?.toList() ?? [];
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<int?> getUserIdByEmail(String email) async {
    final results = await _connection?.execute(
      Sql.named('''
      SELECT id 
      FROM usersdata
      WHERE email = @email
      '''),
      parameters: {'email': email},
    );

    if (results != null && results.isNotEmpty) {
      return results[0][0] as int;
    } else {
      return null;
    }
  }

  Future<List> getCompanyDataByEmail(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT name, phone, tax, career, address, description FROM companydata WHERE email = @email
      '''), parameters: {'email': email});
      return result?.toList() ?? [];
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectJob(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT id, name, salary, category, address, quantity,  
          schedule, gender, age, education, experience, career,
          description, otherRequirements, benefits FROM job WHERE email = @email
      '''), parameters: {'email': email});
      print('select thành công');
      return result?.toList() ?? [];
    } catch (e) {
      print('select thất bại: $e');
      return [];
    }
  }

  Future<List<int>> selectAllIdJobs() async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT id FROM job
      '''));
      print('Select all jobs successful');
      final jobIds = result?.map((row) => row[0] as int).toList() ?? [];
      return jobIds;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> selectAllJobSearch() async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(
        Sql.named('''
          SELECT id, name, email, address, salary, career
          FROM job 
        '''),
      );
      if (result == null || result.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> jobList = result
          .map((row) => {
                'id': row[0],
                'name': row[1],
                'email': row[2],
                'address': row[3],
                'salary': row[4],
                'career': row[5],
              })
          .toList();

      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllJobs() async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(
        Sql.named('''
          SELECT id, name, email, address, salary, career
          FROM job 
        '''),
      );
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> jobList = [];
      for (final row in result) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllUsers() async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(
        Sql.named('''
          SELECT *
          FROM usersData 
        '''),
      );
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> userList = [];
      for (final row in result) {
        userList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
          row[6],
          row[7],
          row[8],
          row[9],
        ]);
      }
      return userList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectJobWithCareer(String career) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
          SELECT id, name, email, address, salary, career
          FROM job WHERE career = @career
        '''), parameters: {'career': career});
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> jobList = [];
      for (final row in result) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectJobInter(String category) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
          SELECT id, name, email, address, salary, career
          FROM job WHERE category = @category
        '''), parameters: {'category': category});
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> jobList = [];
      for (final row in result) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllJobWithEmail(String emailc) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
          SELECT id, name, emailu, address, salary 
          FROM apply WHERE emailc = @emailc
        '''), parameters: {
        'emailc': emailc,
      });
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> jobList = [];
      for (final row in result) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllJobWithEmailC(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
          SELECT id, name, email, address, salary 
          FROM job WHERE email = @email
        '''), parameters: {
        'email': email,
      });
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> jobList = [];
      for (final row in result) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<dynamic>> selectDetailJobs(int id) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT * FROM job WHERE id = @id
      '''), parameters: {
        'id': id,
      });
      print('Select detail jobs successful');
      final jobIds = result?.toList() ?? [];
      return jobIds;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllJobPending(
      String? emailu, String status) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT jobId, name, emailc, address, salary FROM apply where emailu = @emailu AND status = @status
      '''), parameters: {
        'emailu': emailu,
        'status': status,
      });
      List<List<dynamic>> jobList = [];
      for (final row in result!) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectAllUserInApply(String? emailc) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT jobid, name, address, salary FROM apply where emailc = @emailc
      '''), parameters: {
        'emailc': emailc,
      });
      List<List<dynamic>> jobList = [];
      for (final row in result!) {
        jobList.add([
          row[0],
          row[1],
          row[2],
          row[3],
        ]);
      }
      return jobList;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<List<dynamic>> selectCompanyWithEmail(String email) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT * FROM companydata WHERE email = @email
      '''), parameters: {
        'email': email,
      });
      print('Select detail jobs successful');
      final jobIds = result?.toList() ?? [];
      return jobIds;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }

  Future<bool?> login(String email, String password) async {
    final conn = DatabaseConnection().connection;
    try {
      // await conn?.execute(Sql.named('TRUNCATE TABLE users;'));

      final result = await conn?.execute(Sql.named('''
        SELECT email, password FROM users WHERE email = @email, password = @password
      '''), parameters: {'email': email, 'password': password});
      return result?.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> signUp(
      BuildContext context, String email, String password, String role) async {
    final conn = DatabaseConnection().connection;
    try {
      // await conn?.execute(Sql.named('TRUNCATE TABLE users;'));
      await conn?.execute(
        Sql.named(
            '''INSERT INTO users(email, password, role) VALUES (@email, @password, @role);'''),
        parameters: {
          'email': email,
          'password': password,
          'role': role,
        },
      );
    } catch (e) {
      print(Error());
    }
  }

  Future<void> addUserData(String email, String role) async {
    final conn = DatabaseConnection().connection;
    try {
      // await conn?.execute(Sql.named('TRUNCATE TABLE users;'));
      await conn?.execute(
        Sql.named(
            '''INSERT INTO usersdata (email, level) VALUES (@email, @level);'''),
        parameters: {
          'email': email,
          'level': role,
        },
      );
    } catch (e) {
      print(Error());
    }
  }

  Future<void> addCompanyData(String email, String role) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            '''INSERT INTO companydata (email, level) VALUES (@email, @level);'''),
        parameters: {
          'email': email,
          'level': role,
        },
      );
    } catch (e) {
      print(Error());
    }
  }

  Future<void> applyJob(
      int id,
      String emailu,
      String emailc,
      String idJob,
      String status,
      String name,
      String address,
      String salary,
      String reason) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            '''INSERT INTO apply (uid, emailu, emailc, jobid, status, name, address, salary, reason) VALUES (@uid, @emailu, @emailc, @jobid, @status, @name, @address, @salary, @reason);'''),
        parameters: {
          'uid': id,
          'emailu': emailu,
          'emailc': emailc,
          'jobid': idJob,
          'status': status,
          'name': name,
          'address': address,
          'salary': salary,
          'reason': reason,
        },
      );
    } catch (e) {
      print('Error(): $e');
    }
  }

  Future<void> addApplicationHistory(String emailu, String emailc, String idJob,
      String status, String reason) async {
    final conn = DatabaseConnection().connection;
    try {
      DateTime now = DateTime.now();
      String formattedTimestamp = now.toString();
      await conn?.execute(
        Sql.named(
            '''INSERT INTO application_history (emailu, emailc, jobid, status,reason, timestamp) VALUES (@emailu, @emailc, @jobid, @status,@reason, @timestamp);'''),
        parameters: {
          'emailu': emailu,
          'emailc': emailc,
          'jobid': idJob,
          'status': status,
          'reason': reason,
          'timestamp': formattedTimestamp,
        },
      );
    } catch (e) {
      print('$e');
    }
  }

  //cập nhật thông tin users khi đăng kí
  Future<void> updateUserData(
      String email,
      String name,
      int phone,
      String birthday,
      String gender,
      String career,
      String address,
      String description) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'UPDATE usersdata SET name = @name, phone = @phone, birthday = @birthday, gender = @gender, career = @career, address = @address, description = @description  WHERE email = @email'),
        parameters: {
          'email': email,
          'name': name,
          'phone': phone,
          'birthday': birthday,
          'gender': gender,
          'career': career,
          'address': address,
          'description': description,
        },
      );
    } catch (e) {
      return;
    }
  }

  //cập nhật thông tin company khi đăng kí
  Future<void> updateCompanyData(String email, String name, int phone,
      String career, String address, String tax, String description) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'UPDATE companydata SET name = @name, phone = @phone, tax = @tax, career = @career, address = @address, description = @description  WHERE email = @email'),
        parameters: {
          'email': email,
          'name': name,
          'phone': phone,
          'tax': tax,
          'career': career,
          'address': address,
          'description': description,
        },
      );
    } catch (e) {
      return;
    }
  }

  Future<void> updateJobSpace(
      String emailu, String jobId, String status, String reason) async {
    final conn = DatabaseConnection().connection;

    try {
      await conn?.execute(
        // Corrected SQL query with comma removed from the end of the WHERE clause
        Sql.named(
            'UPDATE apply SET status = @status, reason = @reason WHERE emailu = @emailu AND jobId = @jobId'),
        parameters: {
          'emailu': emailu,
          'jobId': jobId,
          'status': status,
          'reason': reason
        },
      );
      print('Hủy ứng tuyển thành công');
    } catch (e) {
      print('Hủy ứng tuyển thất bại: $e');
      return;
    }
  }

  Future<void> postJob(
    String email,
    String name,
    String salary,
    String category,
    String address,
    String quantity,
    String schedule,
    String gender,
    String age,
    String education,
    String experience,
    String career,
    String description,
    String otherRequirements,
    String benefits,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            '''INSERT INTO job (email, name, salary, category, address, quantity,  
          schedule, gender, age, education, experience, career, description, otherRequirements, benefits) 
          VALUES (@email, @name, @salary, @category, @address, @quantity, @schedule, @gender, @age, @education, @experience, @career, @description, @otherRequirements, @benefits);'''),
        parameters: {
          'email': email,
          'name': name,
          'salary': salary,
          'category': category,
          'address': address,
          'quantity': quantity,
          'schedule': schedule,
          'gender': gender,
          'age': age,
          'education': education,
          'experience': experience,
          'career': career,
          'description': description,
          'otherRequirements': otherRequirements,
          'benefits': benefits,
        },
      );
      print('Post thành công');
    } catch (e) {
      print('Post thất bại: $e');
    }
  }

  Future<void> deleteJob(int id) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named('''DELETE FROM job  WHERE id = @id;'''),
        parameters: {
          'id': id,
        },
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<dynamic> getUser() async {
    final conn = DatabaseConnection().connection;
    try {
      final result0 = await conn?.execute("Select * from users");
      if (result0 != null) {
        print(result0);
        return result0;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchUserInfoByEmail(
      List<Map<String, dynamic>> appliedUsers, String emailu) async {
    try {
      final foundUser = appliedUsers.firstWhere(
        (user) => user['emailu'] == emailu,
        orElse: () => {},
      );

      if (foundUser.isNotEmpty) {
        return foundUser;
      } else {
        return null;
      }
    } catch (e) {
      print("Lỗi khi tìm kiếm user: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserDataByEmailC(
      String emailc, String status) async {
    final results = await _connection?.execute(
      Sql.named('''
      SELECT u.id, u.name, u.birthday, u.gender, u.career, u.phone, u.address, a.name, a.status, u.email, u.description, a.jobid
      FROM usersdata u 
      JOIN apply a ON u.id = a.uid
      WHERE a.emailc = @emailc AND a.status = @status
      '''),
      parameters: {
        'emailc': emailc,
        'status': status,
      },
    );

    return results!
        .map((row) => {
              'id': row[0],
              'name': row[1],
              'birthday': row[2],
              'gender': row[3],
              'career': row[4],
              'phone': row[5],
              'address': row[6],
              'nameJob': row[7],
              'status': row[8],
              'email': row[9],
              'description': row[10],
              'jobId': row[11],
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchUsersByStatus(
      String emailc, String status) async {
    final conn = DatabaseConnection()._connection;
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT emailu, jobid, name, status, reason
        FROM apply
        WHERE status = @status AND emailc = @emailc
      '''), parameters: {
        'emailc': emailc,
        'status': status,
      });
      print('thành công');
      return result!
          .map((row) => {
                'emailu': row[0],
                'jobid': row[1],
                'name': row[2],
                'status': row[3],
                'reason': row[4],
              })
          .toList();
    } catch (e) {
      print('error: $e');
      return [];
    }
  }

  Future<List<List<dynamic>>> selectApplication(
      String emailu, String emailc, String jobId) async {
    final conn = DatabaseConnection().connection;
    try {
      final result = await conn?.execute(Sql.named('''
          SELECT timestamp, jobId, status, reason
          FROM application_history 
          WHERE emailu = @emailu AND emailc = @emailc AND jobId = @jobId
        '''), parameters: {
        'emailu': emailu,
        'emailc': emailc,
        'jobId': jobId,
      });
      if (result == null || result.isEmpty) {
        return [];
      }
      List<List<dynamic>> ListApplication = [];
      for (final row in result) {
        ListApplication.add([
          row[0],
          row[1],
          row[2],
          row[3],
        ]);
      }
      return ListApplication;
    } catch (e) {
      print('Select all jobs failed: $e');
      return [];
    }
  }
}
