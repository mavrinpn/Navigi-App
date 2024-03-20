import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/meduim_price_manager.dart';
import 'package:smart/models/item/static_localized_parameter.dart';
import 'package:smart/models/medium_price.dart';

part 'medium_price_state.dart';

class MediumPriceCubit extends Cubit<MediumPriceState> {
  final MediumPriceManager _mediumPriceManager;

  MediumPriceCubit({
    required MediumPriceManager mediumPriceManager,
  })  : _mediumPriceManager = mediumPriceManager,
        super(MediumPriceInitial());

  void queryWith({
    required List<StaticLocalizedParameter> parameters,
  }) async {
    emit(MediumPriceLoadingState());
    try {
      String? carMark;
      String? carModel;
      int? year;
      String? complectation;
      String? engine;
      int? mileage;

      for (final param in parameters) {
        if (param.key == 'car_mark') {
          carMark = param.valueFr;
        }
        if (param.key == 'car_model') {
          carModel = param.valueFr;
        }
        if (param.key == 'year') {
          year = int.tryParse(param.valueFr);
        }
        if (param.key == 'complectation') {
          complectation = param.valueFr;
        }
        if (param.key == 'engine') {
          engine = param.valueFr;
        }
        if (param.key == 'mileage') {
          mileage = int.tryParse(param.valueFr);
        }
      }

      if (carMark == null || carModel == null) {
        emit(MediumPriceEmptyState());
      }

      final allResult = await _mediumPriceManager.getWith(
        brand: carMark!,
        model: carModel!,
        year: year,
      );

      if (allResult.isEmpty) {
        emit(MediumPriceEmptyState());
      }

      int resultMediumPrice = allResult.first.price;

      final engineResult =
          allResult.where((element) => element.engine == engine);

      List<MediumPrice> complectionResult = [];
      if (engineResult.isEmpty) {
        complectionResult = allResult
            .where((element) => element.modification == complectation)
            .toList();
      } else {
        resultMediumPrice = engineResult.first.price;
        complectionResult = engineResult
            .where((element) => element.modification == complectation)
            .toList();
      }

      List<MediumPrice> mileageResult = [];
      if (complectionResult.isEmpty) {
        if (mileage != null) {
          if (engineResult.isEmpty) {
            mileageResult = allResult
                .where((element) => (element.mileage > mileage! - 9999 &&
                    element.mileage < mileage + 9999))
                .toList();
          } else {
            mileageResult = engineResult
                .where((element) => (element.mileage > mileage! - 9999 &&
                    element.mileage < mileage + 9999))
                .toList();
          }
        }
      } else {
        resultMediumPrice = complectionResult.first.price;
        mileageResult = complectionResult.where((element) {
          return ((element.mileage > mileage! - 10000) &&
              (element.mileage < mileage + 10000));
        }).toList();
      }

      if (mileageResult.isNotEmpty) {
        int sum = 0;
        for (var element in mileageResult) {
          sum += element.price;
        }
        resultMediumPrice = sum ~/ mileageResult.length;
      }

      emit(MediumPriceSuccessState(mediumPrice: resultMediumPrice));
    } catch (err) {
      emit(MediumPriceFailState());
    }
  }
}
