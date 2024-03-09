import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';
import '../../../managers/creating_announcement_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';

class ByNotByScreen extends StatefulWidget {
  const ByNotByScreen({super.key});

  @override
  State<ByNotByScreen> createState() => _ByNotByScreenState();
}

class _ByNotByScreenState extends State<ByNotByScreen> {
  bool isBy = false;

  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    final width = MediaQuery.of(context).size.width;

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          localizations.typeOfNews,
          style: AppTypography.font20black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isBy = true;
                });
              },
              child: Row(
                children: [
                  CustomCheckBox(
                      isActive: isBy,
                      onChanged: () {
                        setState(() {
                          isBy = true;
                        });
                      }),
                  const SizedBox(width: 14),
                  Text(
                    localizations.new_,
                    style: AppTypography.font16black
                        .copyWith(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  isBy = false;
                });
              },
              child: Row(
                children: [
                  CustomCheckBox(
                      isActive: !isBy,
                      onChanged: () {
                        setState(() {
                          isBy = false;
                        });
                      }),
                  const SizedBox(width: 14),
                  Text(localizations.used,
                      style: AppTypography.font16black
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        width: width - 30,
        text: localizations.continue_,
        callback: () {
          repository.setType(!isBy);
          Navigator.pushNamed(context, '/create_options_screen');
        },
        active: true,
      ),
    );
  }
}
