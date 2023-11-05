import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/messenger/room.dart';
import 'package:smart/utils/fonts.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer(
      {super.key,
      required this.message,
      required this.chatImageUrl,
      required this.otherUser,
      required this.announcementName,
      required this.userOnline});

  ChatContainer.fromRoom(Room room)
      : message = room.lastMessage,
        chatImageUrl = room.announcement.images[0],
        otherUser = room.announcement.creatorData.name,
        announcementName = room.announcement.title,
        userOnline = false;

  final Message? message;
  final String chatImageUrl;
  final String otherUser;
  final String announcementName;
  final bool userOnline;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
        sliver: SliverToBoxAdapter(
            child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/chat_screen');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, offset: Offset.zero, blurRadius: 18)
              ],
            ),
            width: double.infinity,
            height: 102,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                              image: NetworkImage(widget.chatImageUrl),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 100,
                      height: 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.otherUser,
                                style: AppTypography.font12lightGray,
                              ),
                              if (widget.userOnline) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 2, bottom: 5),
                                  child: SvgPicture.asset(
                                    'Assets/icons/online_circle.svg',
                                    width: 5,
                                    height: 5,
                                  ),
                                )
                              ],
                              if (widget.message != null) ...[
                                Spacer(),
                                if (widget.message!.owned &&
                                    widget.message!.wasRead != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: SvgPicture.asset(
                                      'Assets/icons/read_indicator.svg',
                                      width: 18,
                                      height: 18,
                                    ),
                                  )
                                ],
                                Text(
                                  widget.message!.createdAt,
                                  style: AppTypography.font12lightGray,
                                ),
                              ]
                            ],
                          ),
                          Text(
                            widget.announcementName,
                            style: AppTypography.font12dark,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                if (widget.message != null) ...[
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!widget.message!.owned &&
                            widget.message!.wasRead == null) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 3, top: 3),
                            child: SvgPicture.asset(
                              'Assets/icons/new_circle.svg',
                              width: 8,
                              height: 8,
                            ),
                          )
                        ],
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 115,
                          child: Text(
                            widget.message!.content,
                            style: AppTypography.font12lightGray,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        )));
  }
}
