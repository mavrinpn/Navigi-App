import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../bloc/creating/creating_announcement_cubit.dart';
import '../data/creating_announcement_manager.dart';

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
        floatingActionButton: CustomTextButton.orangeContinue(
            isTouch: descriptionController.text.isNotEmpty,
            width: MediaQuery.of(context).size.width - 30,
            text: 'Continuer',
            callback: () {
              repository.setDescription(descriptionController.text);
              BlocProvider.of<CreatingAnnouncementCubit>(context).createAnnouncement();
              Navigator.pushNamed(context, '/loading_screen');
            }));
  }
}
