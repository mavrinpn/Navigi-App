import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/reviews/bloc/reviews_cubit.dart';
import 'package:smart/feature/reviews/ui/widgets/review_list_widget.dart';
import 'package:smart/feature/reviews/ui/widgets/user_score_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.user});

  final UserData user;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool commentAlreadyLeft = false;

  @override
  void didChangeDependencies() {
    context.read<ReviewsCubit>().loadBy(receiverId: widget.user.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 26,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.user.displayName,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.font20black,
        ),
      ),
      floatingActionButton: _checkNeedsButton()
          ? CustomTextButton.orangeContinue(
              active: true,
              width: MediaQuery.of(context).size.width - 30,
              text: localizations.writeComment,
              callback: () {
                Navigator.of(context).pushNamed(
                  AppRoutesNames.createReview,
                  arguments: widget.user,
                );
              },
            )
          : null,
      body: BlocConsumer<ReviewsCubit, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewsSuccessState) {
            if (state.reviews
                .where((element) => element.creatorId == RepositoryProvider.of<AuthRepository>(context).userId)
                .isNotEmpty) {
              setState(() {
                commentAlreadyLeft = true;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is ReviewsSuccessState) {
            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
              children: [
                const SizedBox(height: 24),
                UserScoreWidget(
                  score: widget.user.rating,
                  subtitle: '${state.reviews.length} ${localizations.comments}',
                  bigSize: true,
                ),
                const SizedBox(height: 24),
                ReviewsListWidget(
                  reviews: state.reviews,
                  user: widget.user,
                ),
              ],
            );
          } else if (state is ReviewsFailState) {
            return Center(child: Text(localizations.dataDownloadError));
          } else if (state is ReviewSaveFailState) {
            return Center(child: Text(state.message));
          } else if (state is ReviewSuccessSavedState) {
            context.read<ReviewsCubit>().loadBy(receiverId: widget.user.id);
          }
          return Center(child: AppAnimations.bouncingLine);
        },
      ),
    );
  }

  bool _checkNeedsButton() {
    if (commentAlreadyLeft) {
      return false;
    }
    return widget.user.id != RepositoryProvider.of<AuthRepository>(context).userId;
  }
}
