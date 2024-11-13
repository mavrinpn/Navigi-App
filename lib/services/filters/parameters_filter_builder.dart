import 'package:appwrite/appwrite.dart';
import 'package:smart/managers/managers.dart';
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

  static List<String> getSearchQueries(
    DefaultFilterDto filterData, {
    bool subcategory = false,
    // List<String> synonyms = const [],
  }) {
    List<String> queries = [];

    queries.add(Query.equal(activeAttribute, true));

    if ((filterData.lastId ?? '') != '') {
      queries.add(Query.cursorAfter(filterData.lastId!));
    }

    if (filterData.keyword != null) {
      List<String> frAndQueries = [];
      for (final textRow in filterData.keyword!.nameFr.split(' ')) {
        final queryWord = ' ${textRow.toLowerCase()} ';
        frAndQueries.add(Query.contains('keywords', queryWord));
      }

      List<String> arAndQueries = [];
      for (final textRow in filterData.keyword!.nameAr.split(' ')) {
        final queryWord = ' ${textRow.toLowerCase()} ';
        arAndQueries.add(Query.contains('keywords', queryWord));
      }

      List<String> orQueries = [];
      if (frAndQueries.isNotEmpty) {
        if (frAndQueries.length > 1) {
          orQueries.add(Query.and(frAndQueries));
        } else {
          orQueries.add(frAndQueries.first);
        }
      }
      if (arAndQueries.isNotEmpty) {
        if (arAndQueries.length > 1) {
          orQueries.add(Query.and(arAndQueries));
        } else {
          orQueries.add(arAndQueries.first);
        }
      }

      if (orQueries.length > 1) {
        queries.add(Query.or(orQueries));
      } else if (orQueries.isNotEmpty) {
        queries.add(orQueries.first);
      }
    }

    if (filterData.text != null && filterData.text != '') {
      List<String> categoriesQueries = [];
      List<String> textQueries = [];
      // List<String> synonymsQueries = [];

      // for (final synonim in synonyms) {
      //   if (synonim.toLowerCase() != filterData.text!.toLowerCase()) {
      //     final lowerTextRow = synonim.toLowerCase();
      //     synonymsQueries.add(Query.contains('keywords', lowerTextRow));
      //   }
      // }

      for (final textRow in filterData.text!.split(' ')) {
        final queryWord = ' ${textRow.toLowerCase()} ';
        textQueries.add(Query.contains('keywords', queryWord));

        // if (lowerTextRow.contains('e')) {
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('e', 'é')));
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('e', 'è')));
        // }
        // if (lowerTextRow.contains('é')) {
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('é', 'e')));
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('é', 'è')));
        // }
        // if (lowerTextRow.contains('è')) {
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('è', 'e')));
        //   textQueries.add(Query.contains('keywords', lowerTextRow.replaceAll('è', 'é')));
        // }

        // const arThe = 'ال';
        // RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
        // if (!lowerTextRow.contains(arThe) && arabicRegExp.hasMatch(lowerTextRow)) {
        //   textQueries.add(Query.contains('keywords', '$lowerTextRow$arThe'));
        // }

        for (final category in CategoriesManager.allCategories) {
          for (final subcategory in category.subcategories) {
            final subcategoryWords = subcategory.name.toLowerCase().split(' ');

            if (subcategoryWords.contains(textRow.toLowerCase())) {
              categoriesQueries.add(Query.equal('subcategoryId', subcategory.id));
            }
          }
        }
      }

      List<String> orQueries = [];
      if (textQueries.isNotEmpty) {
        if (textQueries.length > 1) {
          orQueries.add(Query.and(textQueries));
        } else {
          orQueries.add(textQueries.first);
        }
      }
      if (categoriesQueries.isNotEmpty) {
        if (categoriesQueries.length > 1) {
          orQueries.add(Query.and(categoriesQueries));
        } else {
          orQueries.add(categoriesQueries.first);
        }
      }
      // if (synonymsQueries.isNotEmpty) {
      //   if (synonymsQueries.length > 1) {
      //     orQueries.add(Query.and(synonymsQueries));
      //   } else {
      //     orQueries.add(synonymsQueries.first);
      //   }
      // }

      if (orQueries.length > 1) {
        queries.add(Query.or(orQueries));
      } else if (orQueries.isNotEmpty) {
        queries.add(orQueries.first);
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
