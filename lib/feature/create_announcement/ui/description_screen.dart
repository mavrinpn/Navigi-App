import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../managers/creating_announcement_manager.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../bloc/creating/creating_announcement_cubit.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    titleController.text = repository.creatingData.title!;

    descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: descriptionController.text.length));
    titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: titleController.text.length));

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Informations',
            style: AppTypography.font20black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Titre',
                        style: AppTypography.font16black.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 5),
                    OutLineTextField(
                      hintText: 'name',
                      controller: titleController,
                      maxLines: 5,
                      height: 100,
                      width: double.infinity,
                      maxLength: 100,
                      onChange: (value) {
                        if (value.isNotEmpty) {
                          repository.setTitle(value);
                        } else {
                          repository.setTitle(repository.buildTitle);
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        localizations.description,
                        style: AppTypography.font16black.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 5),
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
            ],
          ),
        ),
        floatingActionButton: CustomTextButton.orangeContinue(
            active: descriptionController.text.isNotEmpty && titleController.text.isNotEmpty,
            width: MediaQuery.of(context).size.width - 30,
            text: 'Continuer',
            callback: () {
              repository.setDescription(descriptionController.text);
              repository.setTitle(titleController.text);
              repository.setInfoFormItem();
              BlocProvider.of<CreatingAnnouncementCubit>(context).createAnnouncement();
              Navigator.pushNamed(context, '/loading_screen');
            }));
  }
}
