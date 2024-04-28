part of '../database_service.dart';

class UserService {
  final Databases _databases;
  final Functions _functions;
  final Account _account;

  UserService(Databases databases, Functions functions, Account account)
      : _databases = databases,
        _account = account,
        _functions = functions;

  Future<void> createUser({
    required String name,
    required String uid,
    required String phone,
  }) async {
    //TODO user check
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
      );
    } else {
      final data = {};
      if (name != '') {
        data[userName] = name;
      }
      if (phone != '') {
        data[userPhone] = phone;
      }
      await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: data,
      );
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

  Future<String> getJwt() => _account.createJWT().then((value) => value.jwt);

  Future<void> sendSms() async {
    final jwt = await getJwt();
    final res = await _functions.createExecution(
      functionId: '658d94ecc79d136f5fec',
      body: jsonEncode({'jwt': jwt}),
    );
    // ignore: avoid_print
    print('sendSms ${res.responseBody}');
    log('sms sent');
  }

  Future<void> sendEmailCode() async {
    final jwt = await getJwt();
    final res = await _functions.createExecution(
      //TODO sendEmailCode
      functionId: '658d94ecc79d136f5fec',
      body: jsonEncode({'jwt': jwt}),
    );
    // ignore: avoid_print
    print('sendEmailCode ${res.responseBody}');
    log('Email code sent');
  }

  Future<(UserCredentials?, bool)> confirmCode(String code, String password) async {
    final jwt = await getJwt();
    final body = jsonEncode({'jwt': jwt, 'code': code, 'password': password});

    final res = await _functions.createExecution(
      functionId: '658d94c13158a0f7ba5b',
      body: body,
    );

    final resBody = jsonDecode(res.responseBody);

    try {
      return Future.value((UserCredentials.fromJson(resBody), resBody['user_exist'] as bool));
    } catch (e) {
      return Future.value((null, false));
    }
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
