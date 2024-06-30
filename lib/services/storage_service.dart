import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

import '../utils/constants.dart';

class FileStorageManager {
  Client client;
  final Storage _storage;

  FileStorageManager({required this.client}) : _storage = Storage(client);

  Future<List<String>> uploadMessageImages(List<Uint8List> listOfBytes) async {
    List<String> urlsList = [];

    for (var bytes in listOfBytes) {
      final url = await _uploadImage(chatImagesBucket, bytes);
      urlsList.add(url);
    }
    return urlsList;
  }

  Future<List<String>> uploadAnnouncementImages(List<Uint8List> listOfBytes) async {
    List<String> urlsList = [];

    for (var bytes in listOfBytes) {
      final url = await _uploadImage(announcementsBucketId, bytes);
      urlsList.add(url);
    }
    return urlsList;
  }

  Future<String> uploadAvatar(Uint8List bytes) => _uploadImage(avatarsBucketId, bytes);

  Future<String> uploadThumb(Uint8List bytes) => _uploadImage(announcementsBucketId, bytes);

  Future<String> _uploadImage(String bucketId, Uint8List bytes) async {
    final res = await _storage.createFile(
        bucketId: bucketId, fileId: ID.unique(), file: InputFile.fromBytes(bytes: bytes, filename: 'image.jpg'));
    return createViewUrl(res.$id, bucketId);
  }

  Future<void> deleteImage(String fileID, String bucketID) => _storage.deleteFile(bucketId: bucketID, fileId: fileID);

  // String createViewUrl(String fileID, String bucketID) =>
  //     'http://admin.navigidz.online/v1/storage/buckets/$bucketID/files/$fileID/view?project=64fb37419dc681fa6860';
  String createViewUrl(String fileID, String bucketID) =>
      '$serviceProtocol$serviceDomain/v1/storage/buckets/$bucketID/files/$fileID/view?project=65d8fa703a95c4ef256b';
}
