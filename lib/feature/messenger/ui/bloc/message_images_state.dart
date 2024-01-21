part of 'message_images_cubit.dart';

@immutable
abstract class MessageImagesState {}

class MessageImagesInitial extends MessageImagesState {}

class ImagesLoadingState extends MessageImagesState {}

class ImagesSentState extends MessageImagesState {}

class ImagesFailState extends ImagesSentState {}