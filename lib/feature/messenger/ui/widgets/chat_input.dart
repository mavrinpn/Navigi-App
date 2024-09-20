import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/create_announcement/ui/widgets/add_image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/image.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.messageController,
    required this.onChange,
    required this.send,
    required this.images,
    required this.blocked,
  });

  final bool blocked;
  final TextEditingController messageController;
  final Function(String?) onChange;
  final VoidCallback send;
  final List<XFile> images;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final messageTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppColors.whiteGray));

  void pickImages() async {
    final localizations = AppLocalizations.of(context)!;
    if (!widget.blocked) {
      final newImages = await ImagePicker().pickMultiImage();
      widget.images.addAll(newImages);
      setState(() {});
    } else {
      CustomSnackBar.showSnackBar(context, localizations.chatBlocked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: widget.images.isEmpty ? 64 : 200,
      width: MediaQuery.sizeOf(context).width,
      color: AppColors.backgroundLightGray,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: widget.images.isEmpty
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (widget.images.isEmpty) ...[
                InkWell(
                  onTap: pickImages,
                  child: SvgPicture.asset(
                    'Assets/icons/attach.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      readOnly: widget.blocked,
                      controller: widget.messageController,
                      onChanged: widget.onChange,
                      cursorColor: AppColors.red,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                          hintText: localizations.messages,
                          hintStyle: AppTypography.font14lightGray,
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          focusedBorder: messageTextFieldBorder,
                          enabledBorder: messageTextFieldBorder,
                          disabledBorder: messageTextFieldBorder,
                          border: messageTextFieldBorder,
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                )
              ],
              const SizedBox(width: 12),
              InkWell(
                onTap: widget.send,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.messageController.text.isNotEmpty ||
                              widget.images.isNotEmpty
                          ? AppColors.red
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    'Assets/icons/send.svg',
                    colorFilter: ColorFilter.mode(
                      widget.messageController.text.isNotEmpty ||
                              widget.images.isNotEmpty
                          ? Colors.white
                          : AppColors.darkGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            ],
          ),
          if (widget.images.isNotEmpty) ...[
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                itemCount: widget.images.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 113,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 7,
                    crossAxisCount: 3),
                itemBuilder: (_, int index) {
                  if (index != widget.images.length) {
                    return ImageWidget(
                      path: widget.images[index].path,
                      callback: () {
                        widget.images.removeAt(index);
                        setState(() {});
                      },
                    );
                  } else {
                    return AddImageWidget(
                      callback: pickImages,
                    );
                  }
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
