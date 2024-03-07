import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/utils/utils.dart';

class FavouriteIndicator extends StatelessWidget {
  const FavouriteIndicator({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavouritesCubit>();

    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state1) {
        bool liked = cubit.isLiked(postId);
        return GestureDetector(
          onTap: () {
            cubit.likeUnlike(postId);
          },
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: SvgPicture.asset(
                'Assets/icons/follow.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  liked ? AppColors.red : AppColors.whiteGray,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
