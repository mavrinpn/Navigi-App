import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/messenger/ui/widgets/image_message.dart';
import 'package:smart/feature/messenger/ui/widgets/message_widget.dart';
import 'package:smart/feature/search/ui/loading_mixin.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/accuont/user_avatar.dart';

class MessageGroupWidget extends StatelessWidget with LoadingMixin {
  const MessageGroupWidget({
    super.key,
    required this.data,
    required this.avatarUrl,
    required this.otherUserName,
  });

  final String avatarUrl;
  final String otherUserName;
  final MessagesGroupData data;

  List<Widget> generateMessages() {
    List<Widget> items = [];
    for (var message in data.messages) {
      if ((message.images ?? []).isEmpty) {
        items.add(MessageContainer(
          text: message.content,
          isCurrentUser: message.owned,
        ));
      } else {
        items.add(ImageMessage(
          imageUrl: message.images!.first,
          isCurrentUser: message.owned,
        ));
      }
    }
    MainAxisAlignment alignment;
    if (!data.owned) {
      alignment = MainAxisAlignment.start;
    } else {
      if (data.wasRead) {
        alignment = MainAxisAlignment.spaceBetween;
      } else {
        alignment = MainAxisAlignment.end;
      }
    }

    items.add(Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (data.owned && data.wasRead) ...[
          SvgPicture.asset(
            'Assets/icons/read_indicator.svg',
            width: 18,
            height: 18,
          ),
        ],
        Text(
          data.sentAtFormatted,
          style: AppTypography.font10lightGray,
        ),
      ],
    ));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!data.owned) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 8),
              child: InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  showLoadingOverlay(context);
                  final userId = data.messages.firstOrNull?.senderId ?? '';
                  BlocProvider.of<CreatorCubit>(context)
                      .setUserData(
                    creatorId: userId,
                    userData: null,
                  )
                      .then((_) {
                    hideLoadingOverlay(context);
                    Navigator.pushNamed(context, AppRoutesNames.announcementCreator);
                  });
                },
                child: UserAvatar(
                  size: 40,
                  imageUrl: avatarUrl,
                  userName: otherUserName,
                ),
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: data.owned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: generateMessages()
                ..add(SizedBox(
                  width: MediaQuery.sizeOf(context).width - (data.owned ? 30 : 78),
                )),
            ),
          ),
        ],
      ),
    );
  }
}
