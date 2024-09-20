import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/reviews/bloc/reviews_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/checkBox/star_row_widget.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({
    super.key,
    required this.user,
  });

  final UserData user;

  @override
  State<CreateReviewScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<CreateReviewScreen> {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  int currentStarIndex = 5;

  @override
  void didChangeDependencies() {
    context.read<ReviewsCubit>().loadBy(receiverId: widget.user.id);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
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
          localizations.writeComment,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.font20black,
        ),
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        active: textController.text.isNotEmpty,
        width: MediaQuery.of(context).size.width - 30,
        text: localizations.publish,
        callback: () {
          focusNode.nextFocus();
          context.read<ReviewsCubit>().addReview(
                score: currentStarIndex,
                text: textController.text,
                receiverId: widget.user.id,
              );
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: StarRowWidget(
                score: currentStarIndex,
                size: 40,
                onTap: (index) {
                  setState(() {
                    currentStarIndex = index + 1;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 18,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: TextField(
                focusNode: focusNode,
                controller: textController,
                minLines: 8,
                maxLines: 8,
                maxLength: 200,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
