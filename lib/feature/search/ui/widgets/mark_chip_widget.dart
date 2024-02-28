import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/select_mark_screen.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/localization/app_localizations.dart';

class MarkChipWidget extends StatefulWidget {
  const MarkChipWidget({super.key});

  @override
  State<MarkChipWidget> createState() => _MarkChipWidgetState();
}

class _MarkChipWidgetState extends State<MarkChipWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateAppBarFilterCubit, UpdateAppBarFilterState>(
      builder: (context, state) {
        final selectCategoryCubit =
            BlocProvider.of<SearchSelectSubcategoryCubit>(context);
        final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
        final isSelected = searchCubit.marksFilter != null;
        final foregroundColor = isSelected ? Colors.white : Colors.black;

        return FilterChip(
          selected: isSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.mark,
                style: TextStyle(color: foregroundColor),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: foregroundColor,
              )
            ],
          ),
          onSelected: (value) async {
            final needSelectModel =
                selectCategoryCubit.subcategoryFilters!.hasModel;
            final List<MarksFilter>? filter = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectMarkScreen(
                  needSelectModel: needSelectModel,
                  subcategory: selectCategoryCubit.subcategoryId!,
                ),
              ),
            );

            if (filter != null && filter.isNotEmpty) {
              setState(() {});
              searchCubit.setMarksFilter(filter.first);
            }
          },
        );
      },
    );
  }
}
