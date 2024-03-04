import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/messenger/bloc/message_images_cubit.dart';
import 'package:smart/feature/messenger/ui/widgets/chat_input.dart';
import 'package:smart/feature/messenger/ui/widgets/message_group_widget.dart';
import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/date_splitter.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/feature/messenger/ui/widgets/announcement_short_info.dart';
import 'package:smart/feature/messenger/ui/widgets/date_splitter_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/messenger_repository.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    this.message,
  });

  final String? message;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController messageController;

  bool preparing = false;
  final messageTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppColors.whiteGray));

  final List<XFile> images = [];

  @override
  void initState() {
    messageController = TextEditingController(text: widget.message ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<MessengerRepository>(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (v) async {
        repository.closeChat();
      },
      child: BlocListener<MessageImagesCubit, MessageImagesState>(
        listener: (context, state) {
          if (state is ImagesLoadingState) {
            Dialogs.showModal(
                context,
                Center(
                  child: AppAnimations.circleFadingAnimation,
                ));
          } else {
            Dialogs.hide(context);
          }
          if (state is ImagesSentState) {
            images.clear();
            setState(() {});
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.backgroundLightGray,
          appBar: AppBar(
            backgroundColor: AppColors.mainBackground,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  launchUrl(Uri.parse(
                      'tel://${repository.currentRoom!.otherUserName}'));
                },
                icon: SvgPicture.asset('Assets/icons/phone.svg'),
              ),
            ],
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    repository.closeChat();
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: 35,
                    height: 48,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      (repository.currentRoom!.otherUserAvatarUrl ?? '')
                              .isNotEmpty
                          ? NetworkImage(
                              repository.currentRoom!.otherUserAvatarUrl ?? '')
                          : null,
                ),
                const SizedBox(width: 10),
                Text(
                  repository.currentRoom!.otherUserName,
                  style: AppTypography.font12lightGray,
                ),
                StreamBuilder(
                    stream: repository.currentRoom!.onlineRefreshStream.stream,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data ?? false
                            ? Container(
                                width: 8,
                                height: 20,
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.only(left: 2, top: 4),
                                child: SvgPicture.asset(
                                  'Assets/icons/online_circle.svg',
                                  width: 4,
                                  height: 4,
                                ),
                              )
                            : Container();
                      }
                      return Container();
                    })
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              color: AppColors.mainBackground,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: AnnouncementShortInfo(
                          announcement: repository.currentRoom!.announcement)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: StreamBuilder<List<ChatItem>>(
                          stream: repository.currentChatItemsStream,
                          initialData: const [],
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemBuilder: (ctx, i) {
                                  final item = snapshot.data![i];
                                  return item is MessagesGroupData
                                      ? MessageGroupWidget(
                                          data: item,
                                          avatarUrl: repository.currentRoom!
                                                  .otherUserAvatarUrl ??
                                              '')
                                      : DateSplitterWidget(
                                          data: item as DateSplitter);
                                },
                                itemCount: snapshot.data!.length,
                                reverse: true);
                          }),
                    ),
                  ),
                  if (preparing) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppAnimations.bouncingLine,
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  ],
                  ChatInput(
                    messageController: messageController,
                    onChange: (s) {
                      setState(() {});
                    },
                    send: () async {
                      if (images.isNotEmpty) {
                        BlocProvider.of<MessageImagesCubit>(context)
                            .sendImages(images);
                        return;
                      }
                      if (messageController.text.isNotEmpty) {
                        setState(() {
                          preparing = true;
                        });

                        await repository.sendMessage(messageController.text);
                        setState(() {
                          messageController.text = '';
                          preparing = false;
                        });
                      }
                    },
                    images: images,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
