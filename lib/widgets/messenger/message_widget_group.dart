import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/messenger/message_widget.dart';

class MessageGroupWidget extends StatelessWidget {
  const MessageGroupWidget(
      {super.key, required this.data, required this.avatarUrl});

  final String avatarUrl;
  final MessagesGroup data;

  List<Widget> groupBable() {
    List<Widget> items = [];
    for (var message in data.messages) {
      items.add(MessageContainer(
          text: message.content, isCurrentUser: message.owned));
    }
    items.add(Row(
      mainAxisAlignment: data.owned
          ? data.wasRead
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!data.owned && data.wasRead) ...[
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!data.owned) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupBable(),
        )
      ],
    );
  }
}
