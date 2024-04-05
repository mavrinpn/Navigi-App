import 'package:appwrite/appwrite.dart';
import 'package:smart/models/sort_types.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/filters/parameter_dto.dart';

import 'filter_dto.dart';

class ParametersFilterBuilder {
  static const String attribute = 'parametrs';
  static const String activeAttribute = 'active';

  static String getFilter(ParameterDto parameter) {
    return Query.search(attribute, '"${parameter.key}": "${parameter.value}"');
  }

  static List<String> getSearchQueries(DefaultFilterDto filterData, {bool subcategory = false}) {
    List<String> queries = [];

    queries.add(Query.equal(activeAttribute, true));

    if ((filterData.lastId ?? '') != '') {
      queries.add(Query.cursorAfter(filterData.lastId!));
    }

    //TODO keyword search
    if (filterData.keyword != null) {
      List<String> frAndQueries = [];
      for (final textRow in filterData.keyword!.nameFr.split(' ')) {
        frAndQueries.add(Query.contains('keywords', textRow.toLowerCase()));
      }

      List<String> arAndQueries = [];
      for (final textRow in filterData.keyword!.nameAr.split(' ')) {
        arAndQueries.add(Query.contains('keywords', textRow.toLowerCase()));
      }

      List<String> orQueries = [Query.and(frAndQueries), Query.and(arAndQueries)];

      if (orQueries.length > 1) {
        queries.add(Query.or(orQueries));
      } else if (orQueries.isNotEmpty) {
        queries.add(orQueries.first);
      }
    }

    //TODO text search
    if (filterData.text != null && filterData.text != '') {
      List<String> orQueries = [];
      for (final textRow in filterData.text!.split(' ')) {
        orQueries.add(Query.contains('keywords', textRow.toLowerCase())); 
      }
      if (orQueries.length > 1) {
        queries.add(Query.or(orQueries));
      } else {
        queries.add(Query.contains('keywords', filterData.text!.toLowerCase()));
      }
    }

    if (filterData.sortBy != null) {
      queries.add(SortTypes.toQuery(filterData.sortBy!)!);
    }
    if (filterData.minPrice != null) {
      queries.add(Query.greaterThanEqual('price', filterData.minPrice));
    }
    if (filterData.maxPrice != null) {
      queries.add(Query.lessThanEqual('price', filterData.maxPrice));
    }
    if (filterData.mark != null) {
      queries.add(Query.equal('mark', filterData.mark));
    }
    if (filterData.model != null) {
      queries.add(Query.equal('model', filterData.model));
    }
    if (filterData.type != null) {
      queries.add(Query.equal('type', filterData.type));
    }

    return queries;
  }

  static List<String> getQueriesForGet(String? lastId) {
    List<String> queries = [
      Query.orderDesc(DefaultDocumentParameters.createdAt),
      Query.equal(activeAttribute, true),
      Query.limit(24)
    ];
    if ((lastId ?? '').isEmpty) lastId = null;

    if (lastId != null) queries.add(Query.cursorAfter(lastId));

    return queries;
  }
}
