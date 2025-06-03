import 'package:get/get.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:referaly/models/model_how_it_works_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SendLeadInfoController extends GetxController {
  late YoutubePlayerController youtubeController;
  RxBool isPlaying = false.obs;
  RxBool isInitialized = false.obs;
  Rx<HowItWorksList?> activity = Rx<HowItWorksList?>(null);
  RxBool playVideo1 = false.obs;
  YoutubePlayerController? videocontroller;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args.containsKey('activity')) {
      activity.value = args['activity'] as HowItWorksList;
      _initializeVideo();
    }
    AppHelper.showLog("Activity: ${activity.value?.videoLink}");
  }

  String videoId = "";
  void _initializeVideo() {
    if (activity.value?.videoLink != null) {
      videoId = extractYoutubeId(activity.value!.videoLink!)!;
      if (videoId != null) {
        videocontroller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }
    }
  }

  void updateActivity(HowItWorksList newActivity) {
    activity.value = newActivity;
    _initializeVideo();
  }

  void playVideo() {
    isPlaying.value = true;
    isInitialized.value = true;
    playVideo1.value = true;
    videocontroller?.play();
  }

  @override
  void onClose() {
    videocontroller?.dispose();
    super.onClose();
  }

  String? extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains('youtube.com')) {
      if (uri.path == '/watch' && uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'live') {
        return uri.pathSegments[1];
      }
    }

    if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }

    return null;
  }
}
