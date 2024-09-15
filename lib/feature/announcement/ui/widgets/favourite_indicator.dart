import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/utils/utils.dart';

class FavouriteIndicator extends StatefulWidget {
  const FavouriteIndicator({super.key, required this.postId});

  final String postId;

  @override
  State<FavouriteIndicator> createState() => _FavouriteIndicatorState();
}

class _FavouriteIndicatorState extends State<FavouriteIndicator> {
  bool _liked = false;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<FavouritesCubit>();
    _liked = cubit.isLiked(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavouritesCubit>();

    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state1) {
        return GestureDetector(
          onTap: () {
            cubit.likeUnlike(widget.postId);
            setState(() {
              _liked = !_liked;
            });
          },
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: SvgPicture.asset(
                'Assets/icons/follow.svg',
                width: 36,
                height: 36,
                colorFilter: ColorFilter.mode(
                  _liked ? AppColors.red : AppColors.whiteGray,
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
