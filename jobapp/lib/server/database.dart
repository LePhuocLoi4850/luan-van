import '../models/company_data.dart';
import './database_connection.dart';
import 'package:postgres/postgres.dart';

class Database {
  final conn = DatabaseConnection().connection;
  CompanyModel? companyModel;

  //favorites

  Future<void> addFavorites(
      int uid,
      int jid,
      int cid,
      String title,
      String nameC,
      String addressC,
      String experienceJ,
      String salaryFromJ,
      String salaryToJ,
      String image,
      DateTime createAt) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO favorites (uid, jid,cid, title, nameC, addressC, experienceJ, salary_fromJ, salary_toJ,imageC, create_at) VALUES (@uid, @jid,@cid, @title, @nameC, @addressC, @experienceJ, @salary_fromJ, @salary_toJ,@imageC, @create_at)
'''), parameters: {
        'uid': uid,
        'jid': jid,
        'cid': cid,
        'title': title,
        'nameC': nameC,
        'addressC': addressC,
        'experienceJ': experienceJ,
        'salary_fromJ': salaryFromJ,
        'salary_toJ': salaryToJ,
        'create_at': createAt,
        'imageC': image
      });
      print('favorites thành công');
    } catch (e) {
      print('thêm favorite thất bại: $e');
    }
  }

  Future<void> removeFavorites(int uid, int jid) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM favorites WHERE uid = @uid AND jid = @jid
'''), parameters: {'uid': uid, 'jid': jid});
      print('remove favorites thành công');
    } catch (e) {
      print('remove favorite thất bại: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllJobFavoriteForUid(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM favorites WHERE uid = @uid
'''), parameters: {'uid': uid});
      return result.map((row) {
        return {
          'uid': row[0],
          'jid': row[1],
          'cid': row[2],
          'title': row[3],
          'nameC': row[4],
          'address': row[5],
          'experience': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'image': row[9],
        };
      }).toList();
    } catch (e) {
      print('fetch all favorites error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllFavoriteForUid(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM favorites WHERE uid = @uid
'''), parameters: {'uid': uid});
      return result.map((row) {
        return {
          'uid': row[0],
          'jid': row[1],
        };
      }).toList();
    } catch (e) {
      print('fetch all favorites error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserDataForUid(int uId) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM users WHERE uid=@uid
'''), parameters: {'uid': uId});
      final row = result.first;
      return {
        'uid': row[0],
        'email': row[1],
        'name': row[2],
        'career': row[3],
        'phone': row[4],
        'gender': row[5],
        'birthday': row[6],
        'address': row[7],
        'description': row[8],
        'salary_from': row[9],
        'salary_to': row[10],
        'image': row[11],
        'experience': row[12],
        'create_at': row[13],
      };
    } catch (e) {
      print('fetch userData error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCvUploadForCvId(int cvId) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM mycv WHERE cv_id = @cv_id
'''), parameters: {'cv_id': cvId});
      final row = result.first;
      return {
        'cv_id': row[0],
        'uid': row[1],
        'name': row[2],
        'time': row[3],
        'pdf': row[4],
      };
    } catch (e) {
      print('fetch cvUpload lỗi: $e');
      rethrow;
    }
  }

  Future<int?> uploadCV(
      int uid, String nameCv, DateTime time, String pdfBase) async {
    try {
      final result = await conn!.execute(Sql.named('''
      INSERT INTO mycv (uid, nameCv, time, pdf) VALUES (@uid, @nameCv, @time, @pdf) RETURNING cv_id
'''), parameters: {
        'uid': uid,
        'nameCv': nameCv,
        'time': time,
        'pdf': pdfBase,
      });
      if (result.isNotEmpty) {
        print('Upload CV  thành công');
        return result.first.toColumnMap()['cv_id'];
      } else {
        return null;
      }
    } catch (e) {
      print('Upload CV  thất bại: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllCvForUid(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM mycv WHERE uid = @uid
'''), parameters: {
        'uid': uid,
      });
      if (result.isEmpty) {
        return [];
      }
      return result.map((row) {
        return {
          'cv_id': row[0],
          'uid': row[1],
          'nameCv': row[2],
          'time': row[3].toString(),
          'pdf': row[4],
        };
      }).toList();
    } catch (e) {
      print('fetch all cv upload for uid lỗi: $e');
      rethrow;
    }
  }

  Future<dynamic> checkForExistingRole(String email) async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT role FROM auth WHERE email = @email
      '''), parameters: {'email': email});
      return result!.first[0].toString();
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<dynamic> selectIdCompanyForEmail(String email) async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT cid FROM company WHERE email = @email
      '''), parameters: {'email': email});
      int value = int.parse(result!.first[0].toString());

      return value;
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<dynamic> selectNameEmail(String email) async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT name FROM auth WHERE email = @email
      '''), parameters: {'email': email});
      String value = result!.first[0].toString();
      return value;
    } catch (e) {
      print('Error checking for existing career: $e');
      return;
    }
  }

  Future<dynamic> selectIdUserForEmail(String email) async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT uid FROM users WHERE email = @email
      '''), parameters: {'email': email});
      int value = int.parse(result!.first[0].toString());

      return value;
    } catch (e) {
      print('Error checking for existing email: $e');
      return;
    }
  }

  Future<dynamic> selectCareerUserForEmail(String email) async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT career FROM users WHERE email = @email
      '''), parameters: {'email': email});
      String value = result!.first[0].toString();
      return value;
    } catch (e) {
      print('Error checking for existing career: $e');
      return;
    }
  }

  Future<String> checkApplicationStatus(int jid, int uid) async {
    try {
      final result = await conn?.execute(Sql.named('''
      SELECT status FROM apply WHERE jid = @jid AND uid=@uid
      '''), parameters: {
        'jid': jid,
        'uid': uid,
      });

      if (result!.isNotEmpty) {
        String status = result.first[0].toString();
        return status;
      } else {
        return 'apply';
      }
    } catch (e) {
      print('Error checking application status: $e');
      return 'Lỗi';
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllJob(bool status) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.jid, j.title,j.career, j.salary_from, j.salary_to, j.experience, j.expiration_date FROM company c JOIN job j ON c.cid = j.cid WHERE status = @status
    '''), parameters: {
        'status': status,
      });
      return result.map((row) {
        return {
          'cid': row[0],
          'name': row[1],
          'address': row[2],
          'image': row[3],
          'jid': row[4],
          'title': row[5],
          'careerJ': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'experience': row[9],
          'expiration_date': row[10],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllJobSearch(bool status) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.jid, j.title, j.career, j.salary_from, j.salary_to, j.experience, j.expiration_date, j.type FROM company c JOIN job j ON c.cid = j.cid WHERE status = @status
    '''), parameters: {
        'status': status,
      });
      return result.map((row) {
        return {
          'cid': row[0],
          'nameC': row[1],
          'address': row[2],
          'image': row[3],
          'jid': row[4],
          'title': row[5],
          'careerJ': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'experience': row[9],
          'expiration_date': row[10],
          'type': row[11],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllJobForCid(
      int cId, bool status) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.jid, j.title,j.career, j.salary_from, j.salary_to, j.experience, j.expiration_date FROM company c JOIN job j ON c.cid = j.cid WHERE c.cid = @cid AND status = @status
    '''), parameters: {
        'cid': cId,
        'status': status,
      });
      return result.map((row) {
        return {
          'cid': row[0],
          'nameC': row[1],
          'address': row[2],
          'image': row[3],
          'jid': row[4],
          'title': row[5],
          'careerJ': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'experience': row[9],
          'expiration_date': row[10],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllApplyForStatus(
      int uid, String status) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT * FROM apply WHERE uid = @uid AND status = @status
    '''), parameters: {'uid': uid, 'status': status});
      List<Map<String, dynamic>> applyList = result.map((row) {
        return {
          'apply_id': row[0],
          'jid': row[1],
          'uid': row[2],
          'cid': row[3],
          'nameU': row[4],
          'title': row[5],
          'nameC': row[6],
          'address': row[7],
          'experience': row[8],
          'salaryFrom': row[9],
          'salaryTo': row[10],
          'applyDate': row[11],
          'status': row[12],
          'image': row[13],
        };
      }).toList();
      print('Danh sách apply thành công: $applyList');
      return applyList;
    } catch (e) {
      print('fetch all apply job with status error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllJobApplied(
      String nameC, String status) async {
    try {
      final result = await conn!.execute(Sql.named('''
   SELECT u.uid, u.name, u.career, u.birthday, u.gender, u.address, u.image, a.title, a.status, a.jid, a.cv_id, a.nameCv
      FROM users u 
      JOIN apply a ON u.uid = a.uid
      WHERE a.nameC = @nameC AND a.status = @status
    '''), parameters: {'nameC': nameC, 'status': status});
      List<Map<String, dynamic>> applyList = result.map((row) {
        return {
          'uid': row[0],
          'name': row[1],
          'career': row[2],
          'birthday': row[3],
          'gender': row[4],
          'address': row[5],
          'image': row[6],
          'title': row[7],
          'status': row[8],
          'jid': row[9],
          'cv_id': row[10],
          'nameCv': row[11],
        };
      }).toList();

      return applyList;
    } catch (e) {
      print('fetch all apply job with status error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobForCareer(String career) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.jid, j.title, j.career, j.salary_from, j.salary_to, j.experience, j.expiration_date FROM company c JOIN job j ON c.cid = j.cid WHERE j.career = @career
    '''), parameters: {
        'career': career,
      });
      return result.map((row) {
        return {
          'cid': row[0],
          'nameC': row[1],
          'address': row[2],
          'image': row[3],
          'jid': row[4],
          'title': row[5],
          'careerJ': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'experience': row[9],
          'expiration_date': row[10],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobForTitle(String title) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.jid, j.title, j.career, j.salary_from, j.salary_to, j.experience, j.expiration_date FROM company c JOIN job j ON c.cid = j.cid WHERE j.title = @title
    '''), parameters: {
        'title': title,
      });
      return result.map((row) {
        return {
          'cid': row[0],
          'nameC': row[1],
          'address': row[2],
          'image': row[3],
          'jid': row[4],
          'title': row[5],
          'careerJ': row[6],
          'salaryFrom': row[7],
          'salaryTo': row[8],
          'experience': row[9],
          'expiration_date': row[10],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserForId(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT DISTINCT ON (u.uid) u.*, e.level AS education 
      FROM users u 
      LEFT JOIN education e ON u.uid = e.uid 
      WHERE u.uid = @uid
      ORDER BY u.uid, 
        CASE 
          WHEN e.level LIKE 'Tốt nghiệp Đại học' THEN 1
          WHEN e.level LIKE 'Tốt nghiệp Cao đẳng' THEN 2
          WHEN e.level LIKE 'Tốt nghiệp THPT' THEN 3
          ELSE 4
        END;
    '''), parameters: {'uid': uid});

      if (result.isEmpty) {
        print('Không tìm thấy người dùng với uid: $uid');
        return {};
      }

      final row = result.first;
      return {
        'uid': row[0],
        'email': row[1],
        'name': row[2],
        'career': row[3],
        'phone': row[4],
        'gender': row[5],
        'birthday': row[6],
        'address': row[7],
        'description': row[8],
        'salaryFrom': row[9],
        'salaryTo': row[10],
        'image': row[11],
        'experience': row[12],
        'create_at': row[13],
        'education': row[14],
      };
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// fetch User Data
  Future<Map<String, dynamic>> fetchUserDataByCid(int cId) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM company WHERE cid = @cid
'''), parameters: {
        'cid': cId,
      });

      if (result.isEmpty) {
        print('Không tìm thấy công ty với cId: $cId');
        return {};
      }
      final row = result.first;
      return {
        'cid': row[0],
        'name': row[1],
        'email': row[2],
        'career': row[3],
        'phone': row[4],
        'address': row[5],
        'scale': row[6],
        'description': row[7],
        'image': row[8],
        'createAt': row[9],
      };
    } catch (e) {
      print('fetch company data error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchJobForId(int jid) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT c.cid, c.name, c.address, c.image, j.* FROM company c JOIN job j ON c.cid = j.cid WHERE j.jid = @jid
    '''), parameters: {
        'jid': jid,
      });
      final row = result.first;
      return {
        'cid': row[0],
        'name': row[1],
        'address': row[2],
        'image': row[3],
        'jid': row[4],
        'title': row[6],
        'careerJ': row[7],
        'type': row[8],
        'quantity': row[9],
        'gender': row[10],
        'salaryFrom': row[11],
        'salaryTo': row[12],
        'experience': row[13],
        'workingTime': row[14],
        'description': row[15],
        'request': row[16],
        'interest': row[17],
        'expirationDate': row[18],
        'status': row[19],
      };
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchJobForJid(int jid) async {
    try {
      final result = await conn!.execute(Sql.named('''
  SELECT * FROM job WHERE jid = @jid
    '''), parameters: {
        'jid': jid,
      });
      final row = result.first;
      return {
        'jid': row[0],
        'cid': row[1],
        'title': row[2],
        'career': row[3],
        'type': row[4],
        'quantity': row[5],
        'gender': row[6],
        'salary_from': row[7],
        'salary_to': row[8],
        'experience': row[9],
        'workingTime': row[10],
        'description': row[11],
        'request': row[12],
        'interest': row[13],
        'expirationDate': row[14],
        'status': row[15],
      };
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<String>> selectAllNameJob() async {
    try {
      final result = await conn?.execute(Sql.named('''
        SELECT title FROM job
      '''));
      final allNameJob =
          result?.map((row) => row[0] as String).toSet().toList() ?? [];
      return allNameJob;
    } catch (e) {
      print('Select all name jobs failed: $e');
      return [];
    }
  }

  Future<void> postJob(
      int cid,
      String title,
      String career,
      String type,
      int quantity,
      String gender,
      String salaryFrom,
      String salaryTo,
      String experience,
      String workingTime,
      String description,
      String request,
      String interest,
      DateTime expirationDate) async {
    try {
      await conn!.execute(Sql.named('''
INSERT INTO job (cid, title, career, type, quantity, gender, salary_from, salary_to, experience, working_time, description, request, interest, expiration_date) 
VALUES (@cid, @title, @career, @type, @quantity, @gender, @salary_from, @salary_to, @experience, @working_time, @description, @request, @interest, @expiration_date)'''),
          parameters: {
            'cid': cid,
            'title': title,
            'career': career,
            'type': type,
            'quantity': quantity,
            'gender': gender,
            'salary_from': salaryFrom,
            'salary_to': salaryTo,
            'experience': experience,
            'working_time': workingTime,
            'description': description,
            'request': request,
            'interest': interest,
            'expiration_date': expirationDate,
          });
      print('Post job nice');
    } catch (e) {
      print('error job: $e');
    }
  }

  Future<void> updateJob(
      int jid,
      String title,
      String career,
      String type,
      int quantity,
      String gender,
      String salaryFrom,
      String salaryTo,
      String experience,
      String workingTime,
      String description,
      String request,
      String interest,
      DateTime expirationDate) async {
    try {
      await conn!.execute(Sql.named('''
UPDATE job SET title = @title, career=@career, type =@type, quantity = @quantity, gender = @gender, salary_from = @salary_from, salary_to = @salary_to, experience = @experience, working_time=@working_time, description=@description, request=@request, interest=@interest, expiration_date=@expiration_date WHERE jid = @jid'''),
          parameters: {
            'jid': jid,
            'title': title,
            'career': career,
            'type': type,
            'quantity': quantity,
            'gender': gender,
            'salary_from': salaryFrom,
            'salary_to': salaryTo,
            'experience': experience,
            'working_time': workingTime,
            'description': description,
            'request': request,
            'interest': interest,
            'expiration_date': expirationDate,
          });
      print('update job thành công');
    } catch (e) {
      print('update job error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobForCid(int cid) async {
    try {
      final result = await conn!.execute(Sql.named('''
SELECT * FROM job WHERE cid = @cid'''), parameters: {
        'cid': cid,
      });
      return result.map((row) {
        return {
          'jid': row[0],
          'cid': row[1],
          'title': row[2],
          'career': row[3],
          'status': row[15],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobForCidAndStatus(
      int cid, bool status) async {
    try {
      final result = await conn!.execute(Sql.named('''
SELECT * FROM job WHERE cid = @cid AND status = @status'''), parameters: {
        'cid': cid,
        'status': status,
      });
      return result.map((row) {
        return {
          'jid': row[0],
          'cid': row[1],
          'title': row[2],
          'career': row[3],
          'status': row[15],
        };
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// apply
  Future<void> apply(
      int jid,
      int uid,
      int cid,
      String nameU,
      String title,
      String nameC,
      String address,
      String experience,
      String salaryFrom,
      String salaryTo,
      DateTime applyDate,
      String status,
      String imageC,
      String imageU,
      int cvId,
      String nameCv) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO apply (jid, uid, cid, nameU, title, nameC, address, experience, salary_from, salary_to, apply_date, status, imageC, imageU, cv_id, nameCv) VALUES (@jid, @uid, @cid, @nameU, @title, @nameC, @address, @experience, @salary_from, @salary_to, @apply_date, @status, @imageC, @imageU, @cv_id, @nameCv)
'''), parameters: {
        'jid': jid,
        'uid': uid,
        'cid': cid,
        'nameU': nameU,
        'title': title,
        'nameC': nameC,
        'address': address,
        'experience': experience,
        'salary_from': salaryFrom,
        'salary_to': salaryTo,
        'apply_date': applyDate,
        'status': status,
        'imageC': imageC,
        'imageU': imageU,
        'cv_id': cvId,
        'nameCv': nameCv,
      });
      print('apply thành công');
    } catch (e) {
      print('Lỗi khi apply: $e');
    }
  }

// withdraw
  Future<void> withdrawAndReapply(
    int jid,
    int uid,
    int cid,
    String status,
    DateTime applyDate,
  ) async {
    try {
      await conn!.execute(Sql.named('''
     UPDATE apply SET status = @status, apply_date = @apply_date WHERE jid = @jid AND uid =@uid AND cid = @cid
'''), parameters: {
        'jid': jid,
        'uid': uid,
        'cid': cid,
        'status': status,
        'apply_date': applyDate,
      });
      print('withdraw and reapply thành công');
    } catch (e) {
      print('Lỗi khi withdraw and reapply: $e');
    }
  }

// save Education

  Future<void> insertEducation(
    int uid,
    String level,
    String name,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
    String career,
  ) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO education (uid, level, name, time_from, time_to, description, career) 
       VALUES (@uid, @level, @name, @time_from, @time_to, @description, @career)
'''), parameters: {
        'uid': uid,
        'level': level,
        'name': name,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description,
        'career': career
      });
      print('thêm học vấn thành công');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEducation(
    int eduId,
    String level,
    String name,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
    String career,
  ) async {
    try {
      await conn!.execute(Sql.named('''
        UPDATE education SET level = @level, name = @name, time_from = @time_from, time_to =@time_to, description = @description, career = @career WHERE edu_id = @edu_id
 '''), parameters: {
        'edu_id': eduId,
        'level': level,
        'name': name,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description,
        'career': career,
      });
      print('cập nhật học vấn thành công');
    } catch (e) {
      print('lỗi cập nhật học vấn: $e');
    }
  }

// save certificate

  Future<void> insertCertificate(
    int uid,
    String nameCertificate,
    String nameHost,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
  ) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO certificate (uid, nameCertificate, nameHost, time_from, time_to, description) 
       VALUES (@uid, @nameCertificate, @nameHost, @time_from, @time_to, @description)
'''), parameters: {
        'uid': uid,
        'nameCertificate': nameCertificate,
        'nameHost': nameHost,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description
      });
      print('thêm chứng chỉ thành công');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCertificate(
    int certId,
    String nameCertificate,
    String nameHost,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
  ) async {
    try {
      await conn!.execute(Sql.named('''
        UPDATE certificate SET nameCertificate = @nameCertificate, nameHost = @nameHost, time_from = @time_from, time_to =@time_to, description = @description WHERE cerTi_id = @cerTi_id
 '''), parameters: {
        'cerTi_id': certId,
        'nameCertificate': nameCertificate,
        'nameHost': nameHost,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description,
      });
      print('thêm học vấn thành công');
    } catch (e) {
      print('lỗi cập nhật certificate: $e');
    }
  }
  // save experience

  Future<void> insertExperience(
    int uid,
    String nameCompany,
    String position,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
  ) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO experience (uid, nameCompany, position, time_from, time_to, description) 
       VALUES (@uid, @nameCompany, @position, @time_from, @time_to, @description)
'''), parameters: {
        'uid': uid,
        'nameCompany': nameCompany,
        'position': position,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description
      });
      print('thêm kinh nghiệm thành công');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateExperience(
    int expeId,
    String nameCompany,
    String position,
    DateTime timeFrom,
    DateTime timeTo,
    String description,
  ) async {
    try {
      await conn!.execute(Sql.named('''
        UPDATE experience SET nameCompany = @nameCompany, position = @position, time_from = @time_from, time_to =@time_to, description = @description WHERE expe_id = @expe_id
 '''), parameters: {
        'expe_id': expeId,
        'nameCompany': nameCompany,
        'position': position,
        'time_from': timeFrom,
        'time_to': timeTo,
        'description': description,
      });
      print('thêm học vấn thành công');
    } catch (e) {
      print('lỗi cập nhật Experience: $e');
    }
  }

//insert Skill
  Future<void> insertSkill(
    int uid,
    String name,
    int rating,
  ) async {
    try {
      await conn!.execute(Sql.named('''
      INSERT INTO skill (uid, nameSkill, rating) 
       VALUES (@uid, @nameSkill, @rating)
'''), parameters: {
        'uid': uid,
        'nameSkill': name,
        'rating': rating,
      });
      print('thêm Kỹ năng thành công');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSkill(
    int skillId,
    String nameSkill,
    int rating,
  ) async {
    try {
      await conn!.execute(Sql.named('''
        UPDATE skill SET nameSkill = @nameSkill, rating = @rating WHERE skill_id = @skill_id
 '''), parameters: {
        'skill_id': skillId,
        'nameSkill': nameSkill,
        'rating': rating,
      });
      print('thêm kỹ năng thành công');
    } catch (e) {
      print('lỗi cập nhật skill: $e');
    }
  }
// Update Profile Company

  Future<void> updateInformationCompany(
    int cid,
    String name,
    String email,
    int phone,
    String scale,
    String career,
    String address,
    String description,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'UPDATE company SET name = @name, email = @email, phone = @phone, scale = @scale, career = @career, address = @address, description = @description WHERE cid = @cid'),
        parameters: {
          'cid': cid,
          'name': name,
          'email': email,
          'phone': phone,
          'scale': scale,
          'career': career,
          'address': address,
          'description': description,
        },
      );
      print('cập nhật thông tin thành công');
    } catch (e) {
      print('cập nhật thông tin công ty thất bại: $e');
      return;
    }
  }

  Future<void> updateImageCompany(
    int cid,
    String image,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named('UPDATE company SET image = @image WHERE cid = @cid'),
        parameters: {
          'cid': cid,
          'image': image,
        },
      );
      print('cập nhật ảnh thành công');
    } catch (e) {
      print('cập nhật ảnh công ty thất bại: $e');
      return;
    }
  }

  // Update Profile UV
  Future<void> updatePersonalInformationUser(
    int uid,
    String email,
    String name,
    String career,
    int phone,
    DateTime birthday,
    String gender,
    int salaryFrom,
    int salaryTo,
    String address,
    String experience,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named(
            'UPDATE users SET email = @email,name = @name,career = @career, phone = @phone, birthday = @birthday, gender = @gender,salary_from = @salary_from,salary_to = @salary_to,address = @address, experience = @experience WHERE uid = @uid'),
        parameters: {
          'uid': uid,
          'email': email,
          'name': name,
          'career': career,
          'phone': phone,
          'birthday': birthday,
          'gender': gender,
          'salary_from': salaryFrom,
          'salary_to': salaryTo,
          'address': address,
          'experience': experience,
        },
      );
    } catch (e) {
      print('Cập nhật thông tin user thất bại: $e');
      return;
    }
  }

// Update image
  Future<void> updateImageUser(
    int uid,
    String image,
  ) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named('UPDATE users SET image = @image WHERE uid = @uid'),
        parameters: {
          'uid': uid,
          'image': image,
        },
      );
      print('cập nhật ảnh thành công');
    } catch (e) {
      print('cập nhật ảnh  thất bại: $e');
      return;
    }
  }

// Update Description

  Future<void> updateDescription(int uid, String description) async {
    try {
      await conn!.execute(
        Sql.named(
            '''UPDATE users SET description = @description WHERE uid = @uid '''),
        parameters: {
          'uid': uid,
          'description': description,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // Update Application in Status
  Future<void> updateApplicantStatus(
      int jid, int uid, String status, String nameC) async {
    try {
      await conn!.execute(
        Sql.named(
            '''UPDATE apply SET status = @status WHERE jid = @jid AND uid = @uid AND nameC = @nameC '''),
        parameters: {
          'jid': jid,
          'uid': uid,
          'status': status,
          'nameC': nameC,
        },
      );
    } catch (e) {
      print(e);
    }
  }
// fetch all information

  Future<List<Map<String, dynamic>>> fetchEducation(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM education WHERE uid=@uid
'''), parameters: {'uid': uid});

      if (result.isEmpty) {
        print('Không tìm thấy bản ghi education nào cho uid = $uid');

        return [];
      } else {
        return result.map((row) {
          return {
            'edu_id': row[0],
            'uid': row[1],
            'level': row[2],
            'name': row[3],
            'career': row[4],
            'time_from': row[5],
            'time_to': row[6],
            'description': row[7],
          };
        }).toList();
      }
    } catch (e) {
      print('error fetch all education: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchExperience(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM experience WHERE uid=@uid
'''), parameters: {'uid': uid});

      if (result.isEmpty) {
        print('Không tìm thấy bản ghi experience nào cho uid = $uid');

        return [];
      } else {
        return result.map((row) {
          return {
            'expe_id': row[0],
            'uid': row[1],
            'nameCompany': row[2],
            'position': row[3],
            'time_from': row[4],
            'time_to': row[5],
            'description': row[6],
          };
        }).toList();
      }
    } catch (e) {
      print('error fetch all experience: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCertificate(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM certificate WHERE uid=@uid
'''), parameters: {'uid': uid});

      if (result.isEmpty) {
        print('Không tìm thấy bản ghi certificate nào cho uid = $uid');

        return [];
      } else {
        return result.map((row) {
          return {
            'cerTi_id': row[0],
            'uid': row[1],
            'nameCertificate': row[2],
            'nameHost': row[3],
            'time_from': row[4],
            'time_to': row[5],
            'description': row[6],
          };
        }).toList();
      }
    } catch (e) {
      print('error fetch all certificate: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSkill(int uid) async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT * FROM skill WHERE uid=@uid
'''), parameters: {'uid': uid});

      if (result.isEmpty) {
        print('Không tìm thấy bản ghi skill nào cho uid = $uid');

        return [];
      } else {
        return result.map((row) {
          return {
            'skill_id': row[0],
            'uid': row[1],
            'nameSkill': row[2],
            'rating': row[3],
          };
        }).toList();
      }
    } catch (e) {
      print('error fetch all skill: $e');
      rethrow;
    }
  }
  // fetch all users

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final result = await conn!.execute(Sql.named('''
     SELECT DISTINCT ON (u.uid) u.*, e.level AS education 
FROM users u 
LEFT JOIN education e ON u.uid = e.uid 
ORDER BY u.uid, 
  CASE 
    WHEN e.name LIKE '%Tốt nghiệp Đại học%' THEN 1
    WHEN e.name LIKE '%Tốt nghiệp Cao đẳng%' THEN 2
    WHEN e.name LIKE '%Tốt nghiệp THPT%' THEN 3
    ELSE 4
  END;
'''));

      return result.map((row) {
        return {
          'uid': row[0],
          'email': row[1],
          'name': row[2],
          'career': row[3],
          'phone': row[4],
          'gender': row[5],
          'birthday': row[6],
          'address': row[7],
          'description': row[8],
          'salaryFrom': row[9],
          'salaryTo': row[10],
          'image': row[11],
          'experience': row[12],
          'create_at': row[13],
          'education': row[14],
        };
      }).toList();
    } catch (e) {
      print('error fetch all users: $e');
      rethrow;
    }
  }

  // fetch all company
  Future<List<Map<String, dynamic>>> fetchAllCompany() async {
    try {
      final result = await conn!.execute(Sql.named('''
      SELECT c.cid, c.name, c.career, c.image, COUNT(j.jid) FROM company c LEFT JOIN job j ON c.cid = j.cid GROUP BY c.cid
'''));
      return result.map((row) {
        return {
          'cid': row[0],
          'name': row[1],
          'career': row[2],
          'image': row[3],
          'countJ': row[4],
        };
      }).toList();
    } catch (e) {
      print('fetch all company error: $e');
      rethrow;
    }
  }

  // DELETE

  Future<void> deleteJob(int jid, bool status) async {
    final conn = DatabaseConnection().connection;
    try {
      await conn?.execute(
        Sql.named('''UPDATE job SET status = @status WHERE jid = @jid;'''),
        parameters: {
          'jid': jid,
          'status': status,
        },
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> deleteExperience(int expeId) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM experience WHERE expe_id = @expe_id 
'''), parameters: {
        'expe_id': expeId,
      });
      print('xóa kinh nghiệm thành công');
    } catch (e) {
      print('xóa kinh nghiệm thất bại');
    }
  }

  Future<void> deleteEducation(int eduId) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM education WHERE edu_id = @edu_id 
'''), parameters: {
        'edu_id': eduId,
      });
      print('xóa học vấn thành công');
    } catch (e) {
      print('xóa học vấn thất bại');
    }
  }

  Future<void> deleteSkill(int skill) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM skill WHERE skill_id = @skill_id 
'''), parameters: {
        'skill_id': skill,
      });
      print('xóa kỹ năng thành công');
    } catch (e) {
      print('xóa kỹ năng thất bại');
    }
  }

  Future<void> deleteCertificate(int certiId) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM certificate WHERE certi_id = @certi_id 
'''), parameters: {
        'certi_id': certiId,
      });
      print('xóa chứng chỉ thành công');
    } catch (e) {
      print('xóa chứng chỉ thất bại');
    }
  }

  Future<void> deleteCvUpload(int cvId) async {
    try {
      await conn!.execute(Sql.named('''
      DELETE FROM myCv WHERE cv_id = @cv_id 
'''), parameters: {
        'cv_id': cvId,
      });
      print('xóa cvUpload thành công');
    } catch (e) {
      print('xóa cvUpload thất bại: $e');
    }
  }

  // update name cv upload
  void updateNameCV(int cvId, String nameCV) async {
    try {
      await conn!.execute(Sql.named('''
      UPDATE myCv SET nameCv = @nameCv WHERE cv_id = @cv_id 
'''), parameters: {
        'cv_id': cvId,
        'nameCv': nameCV,
      });
      print('Đổi tên cv upload thành công');
    } catch (e) {
      print('Lỗi cập nhật tên cv upload');
    }
  }
}
