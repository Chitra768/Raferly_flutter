import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SendLeadInfoController extends GetxController {
  late VideoPlayerController videoController;
  RxBool isPlaying = false.obs;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
        isInitialized.value = true;
        update();
      });
    videoController.addListener(() {
      if (!videoController.value.isPlaying && isPlaying.value) {
        isPlaying.value = false;
        videoController.pause();
      }
    });
  }

  void playVideo() {
    isPlaying.value = true;
    isInitialized.value = true;
    videoController.play();
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
