import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';
import '../../utils/colors.dart';

class PriceWidget extends StatelessWidget {
   PriceWidget({super.key});

  final priseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      child: Column(children: [
        Row(children: [
          SvgPicture.asset(
            'Assets/icons/dzd.svg',
            width: 24,
          ),
          const SizedBox(
            width: 12,
          ),
          Text('Prix', style: AppTypography.font18gray)
        ]),
        const SizedBox(
          height: 14,
        ),
        Row( children: [
          Expanded(
            flex: 3,
            child: SizedBox(
                height: 24,
                child: UnderLineTextField(
                  width: MediaQuery.of(context).size.width * 0.4,
                  hintText: '',
                  keyBoardType: TextInputType.number,
                  suffixIcon: 'DZD',
                  controller: priseController,
                  onChange: (String value) {},
                )),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 17,
                child: Text('—',
                    textAlign: TextAlign.center,
                    style: AppTypography.font18gray
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w400))),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
                height: 24,
                child: UnderLineTextField(
                  width: MediaQuery.of(context).size.width * 0.4,
                  hintText: '',
                  keyBoardType: TextInputType.number,
                  suffixIcon: 'DZD',
                  controller: priseController,
                  onChange: (String value) {},
                )),
          )
        ]),

      ]),
    );
  }
}
