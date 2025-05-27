import 'package:flutter/material.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NfcCardVideoDialog extends StatefulWidget {
  final String videoId;
  const NfcCardVideoDialog({Key? key, required this.videoId}) : super(key: key);

  @override
  State<NfcCardVideoDialog> createState() => _NfcCardVideoDialogState();
}

class _NfcCardVideoDialogState extends State<NfcCardVideoDialog> {
  bool _playVideo = false;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 66),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, color: AppColors.primary, size: 30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _playVideo
                  ? YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://img.youtube.com/vi/${widget.videoId}/0.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _playVideo = true;
                                _controller?.play();
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
