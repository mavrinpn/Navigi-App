import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import 'package:smart/widgets/button/custom_eleveted_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Description',
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              OutLineTextField(
                hintText: 'description',
                controller: descriptionController,
                maxLines: 20,
                height: 310,
                width: double.infinity,
                maxLength: 500,
                onChange: (value) {
                  setState(() {});
                },
              )
            ],
          ),
        ),
        floatingActionButton: CustomElevatedButton(
            isTouch: descriptionController.text.isNotEmpty,
            width: MediaQuery.of(context).size.width - 30,
            padding: const EdgeInsets.all(0),
            height: 52,
            text: 'Continuer',
            styleText: AppTypography.font14white,
            callback: () {
              Navigator.pushNamed(context, '/loading_screen');
            }));
  }
}
