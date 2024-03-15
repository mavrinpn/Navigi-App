import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/widgets/checkBox/custom_check_box.dart';

import '../../utils/fonts.dart';



class UnderLineTextField extends StatelessWidget {
  final double width;
  final double height;
  final int? maxLength;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final ValueChanged<String>? onChange;
  final VoidCallback? onEditingComplete;
  final Function(dynamic)? onTapOutside;
  // final String suffixIcon;
  final PriceType? priceType;
  final Function(PriceType)? onChangePriceType;
  final String? Function(String?)? validator;
  final bool error;

  const UnderLineTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.width = 290,
    this.height = 50,
    this.obscureText = false,
    this.keyBoardType = TextInputType.phone,
    required this.onChange,
    this.onEditingComplete,
    this.onTapOutside,
    this.validator,
    //required this.suffixIcon,
    this.onChangePriceType,
    this.priceType,
    this.error = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        textInputAction: TextInputAction.done,
        maxLength: maxLength,
        validator: validator,
        onTap: () => controller.selection = TextSelection(
            baseOffset: 0, extentOffset: controller.value.text.length),
        onTapOutside: onTapOutside,
        keyboardType: keyBoardType,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        onChanged: onChange,
        onEditingComplete: onEditingComplete,
        style: AppTypography.font16black,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.font14lightGray,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: error ? AppColors.red : AppColors.whiteGray,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: error ? AppColors.red : AppColors.whiteGray,
            ),
          ),
          suffixIcon: onChangePriceType != null
              ? GestureDetector(
                  onTap: () {
                    _showPriceTypeModal(
                      context: context,
                      priceType: priceType ?? PriceType.dzd,
                    ).then((value) {
                      if (value != null) {
                        onChangePriceType!(value);
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        priceType?.name.toUpperCase() ?? '',
                        style: AppTypography.font14lightGray
                            .copyWith(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                )
              : null,
        ),
        controller: controller,
      ),
    );
  }

  Future<PriceType?> _showPriceTypeModal({
    required BuildContext context,
    required PriceType priceType,
  }) {
    final localizations = AppLocalizations.of(context)!;

    return showModalBottomSheet<PriceType?>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      builder: (contex) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: 200,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: ShapeDecoration(
                        color: const Color(0xFFDDE1E7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1))),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(contex).pop(PriceType.dzd),
                  child: Row(
                    children: [
                      CustomCheckBox(
                        isActive: priceType == PriceType.dzd,
                        onChanged: () =>
                            Navigator.of(contex).pop(PriceType.dzd),
                      ),
                      Text(
                        localizations.dzd,
                        style: AppTypography.font14black.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(contex).pop(PriceType.mln),
                  child: Row(
                    children: [
                      CustomCheckBox(
                        isActive: priceType == PriceType.mln,
                        onChanged: () =>
                            Navigator.of(contex).pop(PriceType.mln),
                      ),
                      Text(
                        localizations.mln,
                        style: AppTypography.font14black.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(contex).pop(PriceType.mlrd),
                  child: Row(
                    children: [
                      CustomCheckBox(
                        isActive: priceType == PriceType.mlrd,
                        onChanged: () =>
                            Navigator.of(contex).pop(PriceType.mlrd),
                      ),
                      Text(
                        localizations.mlrd,
                        style: AppTypography.font14black.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
