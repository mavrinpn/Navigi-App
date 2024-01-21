import 'package:flutter/cupertino.dart';
import 'package:smart/utils/fonts.dart';

import '../../../../models/messenger/date_splitter.dart';

class DateSplitterWidget extends StatelessWidget {
  const DateSplitterWidget({super.key, required this.data});

  final DateSplitter data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            data.date,
            style:
                AppTypography.font14black.copyWith(fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
