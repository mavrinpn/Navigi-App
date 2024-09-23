import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/messenger/room.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/functions.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/accuont/user_avatar.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer({
    super.key,
    required this.message,
    required this.chatImageUrl,
    required this.otherUserName,
    required this.otherUserId,
    required this.announcementName,
    required this.userOnline,
    required this.roomId,
    required this.refreshStream,
  });

  ChatContainer.fromRoom(Room room, {super.key})
      : message = room.lastMessage,
        chatImageUrl = room.announcement.images[0],
        otherUserName = room.otherUserName,
        otherUserId = room.otherUserId,
        announcementName = room.announcement.title,
        refreshStream = room.onlineRefreshStream,
        roomId = room.id,
        userOnline = room.online;

  final Message? message;
  final String chatImageUrl;
  final String otherUserName;
  final String otherUserId;
  final String announcementName;
  final bool userOnline;
  final String roomId;
  final BehaviorSubject refreshStream;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SliverPadding(
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
        sliver: SliverToBoxAdapter(
            child: InkWell(
          onTap: () {
            RepositoryProvider.of<MessengerRepository>(context).selectChat(id: widget.roomId);
            Navigator.pushNamed(context, AppRoutesNames.chat);
            // final blockedUsersManager =
            //     RepositoryProvider.of<BlockedUsersManager>(context);

            // blockedUsersManager
            //     .isAuthUserBlockedFor(widget.otherUserId)
            //     .then((isBlocked) {
            //   if (isBlocked) {
            //     CustomSnackBar.showSnackBar(context, localizations.chatBlocked);
            //     RepositoryProvider.of<MessengerRepository>(context)
            //         .selectChat(id: widget.roomId);
            //     Navigator.pushNamed(context, AppRoutesNames.chat);
            //   } else {
            //     RepositoryProvider.of<MessengerRepository>(context)
            //         .selectChat(id: widget.roomId);
            //     Navigator.pushNamed(context, AppRoutesNames.chat);
            //   }
            // });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset.zero, blurRadius: 18)],
            ),
            width: double.infinity,
            height: 102,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      size: 40,
                      imageUrl: widget.chatImageUrl,
                      userName: widget.otherUserName,
                    ),
                    const SizedBox(width: 10),
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
                                widget.otherUserName,
                                style: AppTypography.font12lightGray,
                              ),
                              StreamBuilder(
                                  stream: widget.refreshStream.stream,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 2, bottom: 5),
                                              child: SvgPicture.asset(
                                                'Assets/icons/online_circle.svg',
                                                width: 5,
                                                height: 5,
                                              ),
                                            )
                                          : Container();
                                    }
                                    return widget.userOnline
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 2, bottom: 5),
                                            child: SvgPicture.asset(
                                              'Assets/icons/online_circle.svg',
                                              width: 5,
                                              height: 5,
                                            ),
                                          )
                                        : Container();
                                  }),
                              if (widget.message != null) ...[
                                const Spacer(),
                                if (widget.message!.owned && widget.message!.wasRead != null) ...[
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
                                  dateTimeToString(widget.message!.createdAtDt),
                                  style: AppTypography.font12lightGray,
                                ),
                              ]
                            ],
                          ),
                          Text(
                            widget.announcementName,
                            style: AppTypography.font14dark,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                if (widget.message != null) ...[
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!widget.message!.owned && widget.message!.wasRead == null) ...[
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
                            (widget.message!.images ?? []).isEmpty ? widget.message!.content : localizations.photo,
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
