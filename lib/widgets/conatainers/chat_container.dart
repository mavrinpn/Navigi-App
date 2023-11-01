import 'package:flutter/material.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/utils/fonts.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer(
      {super.key,
      required this.message,
      required this.chatImageUrl,
      required this.otherUser,
      required this.announcementName});

  final Message message;
  final String chatImageUrl;
  final String otherUser;
  final String announcementName;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset.zero, blurRadius: 18)
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.otherUser,
                          style: AppTypography.font12lightGray,
                        ),
                        Text(
                          widget.message.createdAt,
                          style: AppTypography.font12lightGray,
                        ),
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
          SizedBox(
            width: MediaQuery.sizeOf(context).width - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.content,
                  style: AppTypography.font12lightGray,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
