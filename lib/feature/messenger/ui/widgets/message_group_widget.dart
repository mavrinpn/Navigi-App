import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/messenger/ui/widgets/image_message.dart';
import 'package:smart/feature/messenger/ui/widgets/message_widget.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/utils/fonts.dart';

class MessageGroupWidget extends StatelessWidget {
  const MessageGroupWidget({
    super.key,
    required this.data,
    required this.avatarUrl,
  });

  final String avatarUrl;
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
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    avatarUrl != '' ? NetworkImage(avatarUrl) : null,
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: data.owned
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: generateMessages()
                ..add(SizedBox(
                  width:
                      MediaQuery.sizeOf(context).width - (data.owned ? 30 : 78),
                )),
            ),
          ),
        ],
      ),
    );
  }
}
