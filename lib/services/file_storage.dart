import 'package:appwrite/appwrite.dart';

class FileStorageManager {
  Client client;
  Storage storage;

  static const imagesBucketID = '649ede424463483828b7';

  FileStorageManager({required this.client}) : storage = Storage(client);

  Future<List<String>> uploadImages(List<String> listOfPaths) async {
    try {
      List<String> urlsList = [];

      for (var path in listOfPaths) {
        final file = await storage.createFile(bucketId: imagesBucketID, fileId: ID.unique(), file: InputFile.fromPath(path: path));
        urlsList.add(file.$id);
      }
      return urlsList;

    } catch (e) {
      rethrow;
    }
  }
}