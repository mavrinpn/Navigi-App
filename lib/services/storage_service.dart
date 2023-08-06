import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

import '../utils/constants.dart';

class FileStorageManager {
  Client client;
  final Storage _storage;

  FileStorageManager({required this.client}) : _storage = Storage(client);

  Future<List<String>> uploadImages(List<Uint8List> listOfBytes) async {
      List<String> urlsList = [];

      for (var bytes in listOfBytes) {
        final file = await _storage.createFile(bucketId: announcementsBucketId, fileId: ID.unique(), file: InputFile.fromBytes(bytes: bytes, filename: 'image.jpg'));
        urlsList.add(createViewUrl(file.$id, file.bucketId));
      }
      return urlsList;
  }

  Future<String> uploadAvatar(Uint8List bytes) async {
    final res = await _storage.createFile(bucketId: avatarsBucketId, fileId: ID.unique(), file: InputFile.fromBytes(bytes: bytes, filename: 'userAvatar'));
    return createViewUrl(res.$id, avatarsBucketId);
  }

  String createViewUrl(String fileID, String bucketID) =>
      'http://89.253.237.166/v1/storage/buckets/$bucketID/files/$fileID/view?project=64987d0f7f186b7e2b45';
}