import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/ui/widgets/history_item.dart';
import 'package:smart/managers/search_manager.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget(
      {super.key, required this.onDelete, required this.onSearch});

  final Function(String e) onDelete;
  final Function(String e) onSearch;

  @override
  Widget build(BuildContext context) {
    final searchManager = RepositoryProvider.of<SearchManager>(context);

    return FutureBuilder(
        future: searchManager.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data!
                  .map((e) => HistoryItem(
                      name: e.toString(),
                      deleteCallback: () {
                        onDelete(e);
                      },
                      setSearchCallback: () {
                        onSearch(e);
                      }))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
