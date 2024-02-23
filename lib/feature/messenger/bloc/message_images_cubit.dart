import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';

part 'message_images_state.dart';

class MessageImagesCubit extends Cubit<MessageImagesState> {
  MessageImagesCubit(this.messengerRepository) : super(MessageImagesInitial());

  final MessengerRepository messengerRepository;

  void sendImages(List<XFile> images) async {
    emit(ImagesLoadingState());
    try {
      await messengerRepository.sendImages(images);
      emit(ImagesSentState());
    } catch (e) {
      emit(ImagesFailState());
    }
  }
}
