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

  static List<String> getSearchQueries(DefaultFilterDto filterData,
      {bool subcategory = false}) {
    List<String> queries = [];

    queries.add(Query.equal(activeAttribute, true));

    if ((filterData.lastId ?? '' ) != '') {
      queries.add(Query.cursorAfter(filterData.lastId!));
    }
    if ((filterData.text ?? '') != '') {
      queries.add(Query.search(subcategory ? 'title' : 'name', filterData.text!));
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