import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({super.key, required this.postId});

  final String postId;

  @override
  State<ShareButton> createState() => _FavouriteIndicatorState();
}

class _FavouriteIndicatorState extends State<ShareButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state1) {
        return InkWell(
          onTap: () {
            final uri = Uri.parse('https://navigidz.online/panel/announcements-promo/?id=${widget.postId}');
            Share.shareUri(uri);
          },
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: SvgPicture.asset(
                'Assets/icons/share.svg',
                width: 22,
                height: 22,
              ),
            ),
          ),
        );
      },
    );
  }
}
