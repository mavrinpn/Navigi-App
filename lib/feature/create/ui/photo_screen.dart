import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_eleveted_button.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Ajouter une annonce',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 13),
                child: Text(
                  'Pharetra ultricies ullamcorper a et magna convallis condimentum. Proin mi orci dignissim lectus nulla neque',
                  style: AppTypography.font14lightGray,
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: CustomElevatedButton(
        width: width - 30,
        padding: const EdgeInsets.all(0),
        height: 52,
        text: 'Continuer',
        styleText: AppTypography.font14white,
        callback: () {
          if (true) {
            Navigator.pushNamed(context, '/create_by_not_by_screen');
          }
        },
        isTouch: true,
      ),
    );
  }
}
