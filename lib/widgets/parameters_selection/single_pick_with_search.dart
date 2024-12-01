import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart/main.dart';
import 'package:smart/services/parameters_parser.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

class SinglePickWithSearch extends StatefulWidget {
  const SinglePickWithSearch({
    super.key,
    required this.parameter,
    required this.onChange,
  });

  final dynamic parameter;
  final Function(dynamic parametrOption) onChange;

  @override
  State<SinglePickWithSearch> createState() => _SinglePickWithSearchState();
}

class _SinglePickWithSearchState extends State<SinglePickWithSearch> {
  final searchController = TextEditingController();

  List searchedValues = <ParameterOption>[];

  void searchValues(String? query) {
    searchedValues.clear();

    for (var i in widget.parameter.variants) {
      if ((MyApp.getLocale(context) == 'fr' ? i.nameFr : i.nameAr)
          .toLowerCase()
          .contains((query ?? '').toLowerCase())) {
        searchedValues.add(i);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    searchedValues.clear();
    searchedValues = List.from(widget.parameter.variants);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnderLineTextField(
          hintText: 'search...',
          controller: searchController,
          onChange: searchValues,
          keyBoardType: TextInputType.text,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 400,
          child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: searchedValues.length,
              itemBuilder: (context, index) {
                final e = searchedValues[index];

                return GestureDetector(
                  onTap: () {
                    widget.parameter.setVariant(e);
                    setState(() {});
                    widget.onChange(e);
                  },
                  child: Row(
                    children: [
                      CustomCheckBox(
                          isActive: e == widget.parameter.currentValue,
                          onChanged: () {
                            widget.parameter.setVariant(e);
                            setState(() {});
                            widget.onChange(e);
                          }),
                      Expanded(
                        child: Text(
                          MyApp.getLocale(context) == 'fr' ? e.nameFr : e.nameAr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.font14black.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}
