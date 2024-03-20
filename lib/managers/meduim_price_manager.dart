import 'package:appwrite/appwrite.dart';
import 'package:smart/models/medium_price.dart';
import 'package:smart/services/database/database_service.dart';

class MediumPriceManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  MediumPriceManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<List<MediumPrice>> getWith({
    required String brand,
    required String model,
    required int? year,
  }) async {
    return databaseService.mediumPrices.getWith(
      brand: brand,
      model: model,
      year: year,
    );
  }
}
