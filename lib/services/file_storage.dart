import 'package:appwrite/appwrite.dart';

import '../utils/constants.dart';

class FileStorageManager {
  Client client;
  Storage storage;

  FileStorageManager({required this.client}) : storage = Storage(client);

  Future<List<String>> uploadImages(List<String> listOfPaths) async {
    try {
      List<String> urlsList = [];

      for (var path in listOfPaths) {
        final file = await storage.createFile(bucketId: announcementsImagesId, fileId: ID.unique(), file: InputFile.fromPath(path: path));
        urlsList.add(createViewUrl(file.$id, file.bucketId));
      }
      return urlsList;

    } catch (e) {
      rethrow;
    }
  }

  String createViewUrl(String fileID, String bucketID) =>
      'http://89.253.237.166/v1/storage/buckets/$bucketID/files/$fileID/view?project=64987d0f7f186b7e2b45';
}