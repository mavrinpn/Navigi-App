import 'package:appwrite/appwrite.dart';
import 'package:smart/services/database/database_service.dart';

class BlockedUsersManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  BlockedUsersManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<bool> isAuthUserBlockedFor(String userId) async {
    final user = await account.get();
    final uid = user.$id;

    return databaseService.blockedUsers.checkBlock(
      authorId: userId,
      blockedUserId: uid,
    );
  }

  Future<bool> isUserBlockedForAuth(String userId) async {
    final user = await account.get();
    final uid = user.$id;

    return databaseService.blockedUsers.checkBlock(
      authorId: uid,
      blockedUserId: userId,
    );
  }

  Future<void> block(String userId) async {
    final user = await account.get();
    final uid = user.$id;

    databaseService.blockedUsers.addBlock(
      authorId: uid,
      blockedUserId: userId,
    );
  }

  Future<void> unblock(String userId) async {
    final user = await account.get();
    final uid = user.$id;

    databaseService.blockedUsers.removeBlock(
      authorId: uid,
      blockedUserId: userId,
    );
  }
}
