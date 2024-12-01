part of '../database_service.dart';

class UserService {
  final Databases _databases;
  final Functions _functions;
  final Account _account;

  final sendEmailCodeFunction = '662fb6dee05cdf53d400';
  final confirmEmailFunction = '662fbeae05374336da66';
  final updatePasswordFunction = '662fbfe76c295575a1d0';

  UserService(
    Databases databases,
    Functions functions,
    Account account,
  )   : _databases = databases,
        _account = account,
        _functions = functions;

  Future<void> createUser({
    required String name,
    required String uid,
    required String phone,
  }) async {
    final existsDocument = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: usersCollection,
      queries: [Query.equal('\$id', uid)],
    );
    if (existsDocument.documents.isEmpty) {
      await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: {
          userName: name,
          userPhone: phone,
        },
        permissions: [
          Permission.write(Role.user(uid)),
        ],
      );
    } else {
      final data = {};
      if (name != '') {
        data[userName] = name;
      }
      if (phone != '') {
        data[userPhone] = phone;
      }
      if (data.isNotEmpty) {
        await _databases.updateDocument(
          databaseId: mainDatabase,
          collectionId: usersCollection,
          documentId: uid,
          data: data,
        );
      }
    }
  }

  Future<UserData?> getUserData({required String uid}) async {
    try {
      final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: uid,
      );
      return UserData.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> editProfile({
    required String uid,
    String? name,
    String? phone,
    String? imageUrl,
  }) async {
    final editData = {
      if (name != null) userName: name,
      if (phone != null) userPhone: phone,
      if (imageUrl != null) userImageUrl: imageUrl
    };

    await _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: usersCollection,
      documentId: uid,
      data: editData,
    );
  }

  Future<void> deleteProfile({
    required String uid,
  }) async {
    await _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: usersCollection,
      documentId: uid,
      data: {
        'name': 'USER_DELETED',
        'phone': '',
        'registred_at': null,
        'image_url': null,
        'verified': false,
        'lastSeen': null,
        'rating': null,
      },
    );
  }

  Future<String> getJwt() => _account.createJWT().then((value) => value.jwt);

  // Future<void> sendSms() async {
  //   final jwt = await getJwt();
  //   final res = await _functions.createExecution(
  //     functionId: '658d94ecc79d136f5fec',
  //     body: jsonEncode({'jwt': jwt}),
  //   );
  //   // ignore: avoid_print
  //   print('sendSms ${res.responseBody}');
  //   log('sms sent');
  // }

  Future<void> sendEmailCode(String email) async {
    // final jwt = await getJwt();
    final res = await _functions.createExecution(
      functionId: sendEmailCodeFunction,
      body: jsonEncode({
        'email': email,
      }),
    );
    // ignore: avoid_print
    print('sendEmailCode ${res.responseBody}');
    log('Email code sent');
  }

  Future<String> confirmEmailCode({
    required String code,
    required String email,
  }) async {
    final jwt = await getJwt();
    final body = jsonEncode({
      'jwt': jwt,
      'code': code,
      'email': email,
    });

    final res = await _functions.createExecution(
      functionId: confirmEmailFunction,
      body: body,
    );

    // ignore: avoid_print
    print('confirmEmailCode ${res.responseBody}');

    final resBody = jsonDecode(res.responseBody);

    return Future.value(resBody['status'] != null ? resBody['status'] as String : '');
  }

  Future<String> updatePassword({
    required String code,
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({
      'new_password': password,
      'code': code,
      'email': email,
    });

    final res = await _functions.createExecution(
      functionId: updatePasswordFunction,
      body: body,
    );

    // ignore: avoid_print
    print('updatePassword ${res.responseBody}');

    final resBody = jsonDecode(res.responseBody);

    return Future.value(resBody['status'] != null ? resBody['status'] as String : '');
  }

  static const String lastSeen = 'lastSeen';

  Future<void> updateOnlineStatus(String userId) async {
    final time = DateTime.now();

    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: userId,
        data: {lastSeen: time.millisecondsSinceEpoch});
  }

  Future<DateTime> getLastUserOnline(String userId) async {
    try {
      final res =
          await _databases.getDocument(databaseId: mainDatabase, collectionId: usersCollection, documentId: userId);

      return DateTime.fromMillisecondsSinceEpoch(res.data[lastSeen] ?? 0);
    } catch (err) {
      return DateTime.now();
    }
  }

  Future<bool> userExists(String userId) async {
    try {
      await _databases.getDocument(databaseId: mainDatabase, collectionId: usersCollection, documentId: userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class UserCredentials {
  final String mail;
  final String password;

  UserCredentials({required this.mail, required this.password});

  UserCredentials.fromJson(Map<String, dynamic> json)
      : mail = json['mail'],
        password = json['password'];
}
