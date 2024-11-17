import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

class FavouriteIndicator extends StatefulWidget {
  const FavouriteIndicator({super.key, required this.postId});

  final String postId;

  @override
  State<FavouriteIndicator> createState() => _FavouriteIndicatorState();
}

class _FavouriteIndicatorState extends State<FavouriteIndicator> {
  bool _liked = false;
  bool _lastLikeState = false;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<FavouritesCubit>();
    _liked = cubit.isLiked(widget.postId);
    _lastLikeState = _liked;
  }

  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavouritesCubit>();

    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state1) {
        return GestureDetector(
          onTap: () {
            final localizations = AppLocalizations.of(context)!;

            _debouncer.debounce(
              duration: const Duration(milliseconds: 750),
              onDebounce: () {
                if (_lastLikeState != _liked) {
                  _lastLikeState = _liked;
                  cubit.likeUnlike(widget.postId);
                  CustomSnackBar.showSnackBar(
                    context,
                    _liked ? localizations.adRemovedFromFavorites : localizations.adAddedToFavorites,
                    2,
                  );
                }
              },
            );

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
