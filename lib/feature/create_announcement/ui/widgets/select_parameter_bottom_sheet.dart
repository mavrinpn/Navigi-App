import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class SelectParameterBottomSheet extends StatelessWidget {
  const SelectParameterBottomSheet({
    super.key,
    required this.child,
    required this.title,
    required this.selected,
  });

  final Widget child;
  final String title;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.8,
              ),
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        clipBehavior: Clip.none,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Container(
                                  width: 120,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                      color: const Color(0xFFDDE1E7),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
                                ),
                              ),
                              const SizedBox(height: 20),
                              child,
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: CustomTextButton.orangeContinue(
                          callback: () {
                            Navigator.of(context).pop();
                          },
                          text: localizations.apply,
                          active: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.font16black.copyWith(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected.isNotEmpty)
              Text(
                selected,
                style: AppTypography.font14light,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: AppColors.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}
