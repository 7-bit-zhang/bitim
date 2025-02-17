import 'package:animate_do/animate_do.dart';
import 'package:bit_im/message/message.dart';
import 'package:bit_im/message/widget/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoDetailMessageWidget extends GetView<VideoController> {
  const VideoDetailMessageWidget(
      {super.key, required this.message, required this.messages});
  final Message message;
  final List<Message> messages;
  @override
  String? get tag => message.messageVideo!.url;
  @override
  Widget build(BuildContext context) {
    Get.put(VideoController(message: message, messages: messages),
        tag: message.messageVideo!.url);
    return Obx(
      () => GestureDetector(
        onTap: () => controller.play(),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            AspectRatio(
              aspectRatio: controller.w.value / controller.h.value,
              child: controller.isInited.value
                  ? VideoPlayer(controller.videoPlayerController)
                  : FadeIn(
                      child: SizedBox(
                        width: double.infinity,
                        height: Get.height * 3,
                        child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 245, 245, 245),
                            highlightColor: Colors.white,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)))),
                      ),
                    ),
            ),
            controller.isInited.value
                ? !controller.isPlay.value
                    ? SvgPicture.asset('assets/images/Play_Circle.svg',
                        width: 30,
                        height: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn))
                    : Obx(() => AnimatedOpacity(
                          opacity: controller.playCircleOpacity.value,
                          duration: const Duration(seconds: 3),
                          child: SvgPicture.asset(
                              'assets/images/Pause_Circle.svg',
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn)),
                        ))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
