// ignore_for_file: depend_on_referenced_packages

import 'package:bit_im/chats/chats_model.dart';
import 'package:bit_im/message/message.dart';
import 'package:bit_im/message/message_content_type_enum.dart';
import 'package:bit_im/message/role_enum.dart';
import 'package:bit_im/message/widget/audio_widget.dart';
import 'package:bit_im/message/widget/image_widget.dart';
import 'package:bit_im/message/widget/localImage_widget.dart';
import 'package:bit_im/message/widget/text_widget.dart';
import 'package:bit_im/message/widget/video_widget.dart';
import 'package:bit_im/user/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget(
      {super.key,
      required this.message,
      required this.messages,
      required this.chatsModel});
  final Message message;
  final List<Message> messages;
  final ChatsModel chatsModel;
  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late RoleEnum roleEnum = RoleEnum.i;

  late EdgeInsetsGeometry padding = EdgeInsets.zero;
  @override
  void initState() {
    super.initState();
    initPadding();
  }

  void initPadding() {
    padding = widget.message.contentType == MessageContentType.image ||
            widget.message.contentType == MessageContentType.video ||
            widget.message.contentType == MessageContentType.localImage ||
            widget.message.contentType == MessageContentType.localVideo
        ? const EdgeInsets.all(0)
        : const EdgeInsets.all(10);
  }

  late Widget mseeageContent;
  late String url;

  // Initialise                               // Dispose controller

  //模拟查询用户信息
  initData() {
    //根据用户id查询用户信息 1001默认为用户自己本地存储的用户id
    if (widget.message.senderId == '1001') {
      roleEnum = RoleEnum.i;
      url = UserInfo.URL;
    } else {
      roleEnum = RoleEnum.you;
      url = widget.chatsModel.url;
    }
  }

  void buildMessageContent() async {
    switch (widget.message.contentType) {
      case MessageContentType.text:
        TextStyle style = roleEnum == RoleEnum.i
            ? const TextStyle(color: Colors.white, fontSize: 15)
            : const TextStyle(
                color: Color.fromARGB(255, 48, 31, 31), fontSize: 15);
        mseeageContent = TextMessageWidget(
            message: widget.message.message, textStyle: style);
      case MessageContentType.image:
        mseeageContent = ImageMessageWidget(
            aspectRatio: widget.message.imageInfo!.width /
                widget.message.imageInfo!.height,
            url: widget.message.imageInfo!.url);
      case MessageContentType.audio:
        Color fixedWaveColor = Colors.white54;
        Color liveWaveColor = Colors.white;
        Color seekLineColor = Colors.white;
        if (roleEnum == RoleEnum.you) {
          fixedWaveColor = Colors.black;
          liveWaveColor = Colors.black26;
          seekLineColor = Colors.black;
        }
        mseeageContent = AudioMessageWidget(
            message: widget.message,
            liveWaveColor: liveWaveColor,
            seekLineColor: seekLineColor,
            fixedWaveColor: fixedWaveColor,
            roleEnum: roleEnum,
            messages: widget.messages);
      case MessageContentType.video || MessageContentType.localVideo:
        mseeageContent = VideoMessageWidget(
            message: widget.message, messages: widget.messages);
      case MessageContentType.localImage:
        mseeageContent = LocalImageMessageWidget(
            aspectRatio: widget.message.imageInfo!.width /
                widget.message.imageInfo!.height,
            url: widget.message.imageInfo!.url);
      default:
        mseeageContent = Text(widget.message.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    initData();
    buildMessageContent();
    //假如是自己发送的消息
    return roleEnum == RoleEnum.i ? buildRightMessage() : buildLeftMessage();
  }

  // 右边消息
  buildRightMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: padding,
              decoration: const BoxDecoration(
                  color: Color(0xff0099FF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: mseeageContent),
          const SizedBox(width: 10),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  //左边消息
  buildLeftMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: padding,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: mseeageContent),
        ],
      ),
    );
  }
}
