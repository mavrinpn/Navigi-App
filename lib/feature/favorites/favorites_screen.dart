import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/widgets/category/category.dart';
import 'package:smart/widgets/category/products.dart';
import 'package:smart/widgets/conatainers/announcement.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/accuont/account_medium_info.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/button/custom_text_button.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreen();
}

class _FavoritesScreen extends State<FavoritesScreen>{
  @override
  Widget build(BuildContext context){
    final localizations = AppLocalizations.of(context)!;

    List<Announcement>screenSelection = [];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainBackground,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Favoris', style: AppTypography.font20black),
            ],
          ),
        ),
        // body: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   child: Center(
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text('Vous n\'avez pas de produits sélectionnés'),
        //         SizedBox(height: 14),
        //         CustomTextButton.orangeContinue(callback: () {}, text: 'aller au répertoire', isTouch: true)
        //       ],
        //     ),
        //   ),
        // ),

        body: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  child: Center(
                    child: AnnouncementContainer(announcement: screenSelection[index]),
                  ),
                    color: AppColors.mainBackground,
                ),
                  childCount: screenSelection.length,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 16,
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    childAspectRatio: 160/272
                )
            ),
          ],
        ),
      ),
    );
  }
}