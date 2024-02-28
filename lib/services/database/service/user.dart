part of '../database_service.dart';

class UserService {
  final Databases _databases;
  final Functions _functions;
  final Account _account;

  UserService(Databases databases, Functions functions, Account account)
      : _databases = databases,
        _account = account,
        _functions = functions;

  Future<void> createUser(
      {required String name,
      required String uid,
      required String phone}) async {
    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: {userName: name, userPhone: phone});
  }

  Future<UserData?> getUserData({required String uid}) async {
    try {
      final res = await _databases.getDocument(
          databaseId: mainDatabase,
          collectionId: usersCollection,
          documentId: uid);
      return UserData.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> editProfile(
      {required String uid,
      String? name,
      String? phone,
      String? imageUrl}) async {
    // final editData = {
    //   if (name != null) userName: name,
    //   if (phone != null) userPhone: phone,
    //   if (imageUrl != null) userImageUrl: imageUrl
    // };

    // print(editData);
    // print(uid);

    // final res = await _databases.updateDocument(
    //   databaseId: mainDatabase,
    //   collectionId: usersCollection,
    //   documentId: uid,
    //   data: editData,
    // );
  }

  Future<String> getJwt() => _account.createJWT().then((value) => value.jwt);

  Future<void> sendSms() async {
    final jwt = await getJwt();
    await _functions.createExecution(
        functionId: '658d94ecc79d136f5fec', body: jsonEncode({'jwt': jwt}));
    log('sms sent');
  }

  Future<UserCredentials?> confirmSms(String code, String password) async {
    final jwt = await getJwt();
    final body = jsonEncode({'jwt': jwt, 'code': code, 'password': password});

    final res = await _functions.createExecution(
        functionId: '658d94c13158a0f7ba5b', body: body);

    try {
      return UserCredentials.fromJson(jsonDecode(res.responseBody));
    } catch (e) {
      return null;
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
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: userId);

    return DateTime.fromMillisecondsSinceEpoch(res.data[lastSeen] ?? 0);
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
