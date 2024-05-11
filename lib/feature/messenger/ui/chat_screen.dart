import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/announcement/ui/dialogs/creator_show_more_bottom_sheet.dart';
import 'package:smart/feature/messenger/bloc/message_images_cubit.dart';
import 'package:smart/feature/messenger/chat_function.dart';
import 'package:smart/feature/messenger/ui/widgets/chat_input.dart';
import 'package:smart/feature/messenger/ui/widgets/message_group_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/blocked_users_manager.dart';
import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/date_splitter.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/feature/messenger/ui/widgets/announcement_short_info.dart';
import 'package:smart/feature/messenger/ui/widgets/date_splitter_widget.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

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
  bool _blockIsChecked = false;
  bool _authUserIsBlocked = false;
  bool _otherUserIsBlocked = false;

  bool preparing = false;
  final messageTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.whiteGray));

  final List<XFile> images = [];

  @override
  void initState() {
    messageController = TextEditingController(text: widget.message ?? '');
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);
    //* preloadChats
    messengerRepository.preloadChats();
    messengerRepository.refreshSubscription();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);
    final blockedUsersManager = RepositoryProvider.of<BlockedUsersManager>(context);

    final isAuthUserBlockedFor =
        blockedUsersManager.isAuthUserBlockedFor(messengerRepository.currentRoom?.otherUserId ?? '');

    final isUserBlockedForAuth =
        blockedUsersManager.isUserBlockedForAuth(messengerRepository.currentRoom?.otherUserId ?? '');

    Future.wait([isAuthUserBlockedFor, isUserBlockedForAuth]).then((value) {
      _authUserIsBlocked = value[0];
      _otherUserIsBlocked = value[1];
      _blockIsChecked = true;
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (v) async {
        messengerRepository.closeChat();
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
            backgroundColor: AppColors.appBarColor,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  checkBlockedAndCall(
                    context: context,
                    userId: messengerRepository.currentRoom!.otherUserId,
                    phone: messengerRepository.currentRoom!.otherUserPhone,
                  );
                },
                icon: SvgPicture.asset('Assets/icons/phone.svg'),
              ),
              if (!_otherUserIsBlocked)
                IconButton(
                  onPressed: () {
                    creatorShowMoreAction(
                      context: context,
                      userId: messengerRepository.currentRoom!.otherUserId,
                      onAction: (value) {
                        setState(() {
                          _otherUserIsBlocked = value;
                        });
                      },
                    );
                  },
                  icon: SvgPicture.asset('Assets/icons/menu_dots_vertical.svg'),
                ),
            ],
            titleSpacing: 6,
            title: Row(
              children: [
                const CustomBackButton(),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (messengerRepository.currentRoom!.otherUserAvatarUrl ?? '').isNotEmpty
                      ? NetworkImage(messengerRepository.currentRoom!.otherUserAvatarUrl ?? '')
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  messengerRepository.currentRoom!.otherUserName,
                  style: AppTypography.font12lightGray,
                ),
                StreamBuilder(
                    stream: messengerRepository.currentRoom!.onlineRefreshStream.stream,
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
          body: Container(
            color: AppColors.mainBackground,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: AnnouncementShortInfo(
                    announcement: messengerRepository.currentRoom!.announcement,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: StreamBuilder<List<ChatItem>>(
                        stream: messengerRepository.currentChatItemsStream,
                        initialData: const [],
                        builder: (context, snapshot) {
                          return ListView.builder(
                            itemBuilder: (ctx, i) {
                              final item = snapshot.data![i];
                              return item is MessagesGroupData
                                  ? MessageGroupWidget(
                                      data: item, avatarUrl: messengerRepository.currentRoom!.otherUserAvatarUrl ?? '')
                                  : DateSplitterWidget(
                                      data: item as DateSplitter,
                                    );
                            },
                            itemCount: snapshot.data!.length,
                            reverse: true,
                          );
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
                _buildInputRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _send() async {
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);

    if (images.isNotEmpty) {
      BlocProvider.of<MessageImagesCubit>(context).sendImages(images);
      return;
    }

    if (messageController.text.isNotEmpty) {
      final text = messageController.text;
      setState(() {
        preparing = true;
        messageController.text = '';
      });

      await messengerRepository
          .sendMessage(text)
          .catchError((err) {
            CustomSnackBar.showSnackBar(context, err.toString());
          })
          .timeout(const Duration(seconds: 2))
          .whenComplete(
            () {
              setState(() {
                preparing = false;
              });
            },
          );
    }
  }

  Widget _buildInputRow() {
    final localizations = AppLocalizations.of(context)!;
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);
    final blockedUsersManager = RepositoryProvider.of<BlockedUsersManager>(context);

    if (_otherUserIsBlocked) {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: CustomTextButton.orangeContinue(
                callback: () {
                  final blockedUsersManager = RepositoryProvider.of<BlockedUsersManager>(context);
                  final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);
                  blockedUsersManager.unblock(messengerRepository.currentRoom!.otherUserId);
                  setState(() {
                    _otherUserIsBlocked = false;
                  });
                },
                text: localizations.unblockUser,
                styleText: AppTypography.font14white,
                active: true,
                activeColor: AppColors.dark,
              ),
            ),
            Text(localizations.youBlockedUser(messengerRepository.currentRoom!.otherUserName)),
          ],
        ),
      );
    }

    if (_authUserIsBlocked) {
      return SafeArea(
        child: Text(localizations.userBlockedYou(messengerRepository.currentRoom!.otherUserName)),
      );
    }

    if (_blockIsChecked) {
      return Container(
        color: AppColors.backgroundLightGray,
        child: SafeArea(
          child: ChatInput(
            blocked: _authUserIsBlocked,
            messageController: messageController,
            onChange: (s) {
              setState(() {});
            },
            send: () async {
              blockedUsersManager
                  .isAuthUserBlockedFor(messengerRepository.currentRoom?.otherUserId ?? '')
                  .then((isBlocked) {
                if (isBlocked) {
                  CustomSnackBar.showSnackBar(context, localizations.chatBlocked);
                } else {
                  if (!preparing) {
                    _send();
                  }
                }
              });
            },
            images: images,
          ),
        ),
      );
    }

    return Container();
  }
}
