import 'package:appwrite/appwrite.dart';

import '../utils/constants.dart';

class FileStorageManager {
  Client client;
  Storage _storage;

  FileStorageManager({required this.client}) : _storage = Storage(client);

  Future<List<String>> uploadImages(List<String> listOfPaths) async {

      List<String> urlsList = [];

      for (var path in listOfPaths) {
        final file = await _storage.createFile(bucketId: announcementsBucketId, fileId: ID.unique(), file: InputFile.fromPath(path: path));
        urlsList.add(createViewUrl(file.$id, file.bucketId));
      }
      return urlsList;


  }

  Future<String> uploadAvatar(String path) async {
    final res = await _storage.createFile(bucketId: avatarsBucketId, fileId: ID.unique(), file: InputFile.fromPath(path: path));
    return createViewUrl(res.$createdAt, avatarsBucketId);
  }

  String createViewUrl(String fileID, String bucketID) =>
      'http://89.253.237.166/v1/storage/buckets/$bucketID/files/$fileID/view?project=64987d0f7f186b7e2b45';
}