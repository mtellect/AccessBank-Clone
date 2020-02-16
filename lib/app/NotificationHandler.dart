import 'package:flutter/material.dart';

import 'assets.dart';
import 'basemodel.dart';
import 'notificationService.dart';

enum NotificationType {
  none,
  requestSent,
  requestAccepted,
  figureApproved,
  imageSent,
  tagged,
  pollAnswered,
  quizAnswered,
  commentReplied,
  postShared,
  postLiked,
  commentLiked,
  repliedInMessage,
  repliedInGroup,
  sharedInGroup,
  sharedInRoom,
  invitedToGroup,
  acceptedGroupInvite,
  madeGroupAdmin,
  eventApproved,
  attendingEvent,
  cancelledEvent,
  eventUpdated,
  eventReminder,
  eventMaxGoal,
  challengeCompleted,
  challengeUnlocked,
  eventDeclined,
  postCommented,
}

enum HandlerType { incomingNotification, outgoingNotification }

class NotificationHandler {
  BuildContext context;
  BaseModel bm;

  NotificationHandler(
      BuildContext context, BaseModel bm, HandlerType handlerType,
      {NotificationType notificationType}) {
    this.context = context;
    this.bm = bm;
    switch (handlerType) {
      case HandlerType.incomingNotification:
        handleIncomingNotification(getType(bm.getNotificationType()), bm);
        break;
      case HandlerType.outgoingNotification:
        handleOutgoingNotification(notificationType, bm);
        break;
    }
  }

  handleIncomingNotification(NotificationType type, BaseModel bm) {
    switch (type) {
      case NotificationType.requestSent:
        break;
      case NotificationType.requestAccepted:
        break;
      case NotificationType.figureApproved:
        break;
      case NotificationType.imageSent:
        break;
      case NotificationType.tagged:
        break;
      case NotificationType.pollAnswered:
        break;
      case NotificationType.quizAnswered:
        break;
      case NotificationType.commentReplied:
        break;
      case NotificationType.postShared:
        break;
      case NotificationType.postLiked:
        break;
      case NotificationType.commentLiked:
        break;
      case NotificationType.repliedInMessage:
        break;
      case NotificationType.repliedInGroup:
        break;
      case NotificationType.sharedInGroup:
        break;
      case NotificationType.sharedInRoom:
        break;
      case NotificationType.invitedToGroup:
        break;
      case NotificationType.acceptedGroupInvite:
        break;
      case NotificationType.madeGroupAdmin:
        break;
      case NotificationType.eventApproved:
        break;

      case NotificationType.attendingEvent:
        break;
      case NotificationType.cancelledEvent:
        break;
      case NotificationType.eventUpdated:
        break;
      case NotificationType.eventReminder:
        break;
      case NotificationType.eventMaxGoal:
        break;
      case NotificationType.challengeCompleted:
        break;
      case NotificationType.challengeUnlocked:
        break;
      case NotificationType.eventDeclined:
        break;
      case NotificationType.postCommented:
        break;

      case NotificationType.none:
        break;
    }
  }

  handleOutgoingNotification(NotificationType type, BaseModel bm) {
    int notificationType = setIntType(type);
    bm.put(NOTIFICATION_TYPE, notificationType);
    bm.put(NOTIFICATION_STATUS, NOTIFICATION_NOT_SEEN);
    NotificationService.sendPushTo(
        title: bm.getString(TITLE),
        message: bm.getString(MESSAGE),
        payload: bm,
        fcmToken: bm.getToken(),
        image: bm.getImage());
    //print("Handler ${bm.items}");
    //print("Handler ${bm.getToken()}");
    //print("Handler ${bm.getPushToken()}");
    bm.saveItem(NOTIFICATION_BASE, false,
        document: bm.getObjectId(), onComplete: () {});
  }

  static NotificationType getType(int type) {
    if (type == 0) return NotificationType.requestSent;
    if (type == 1) return NotificationType.requestAccepted;
    if (type == 2) return NotificationType.figureApproved;
    if (type == 3) return NotificationType.imageSent;
    if (type == 4) return NotificationType.tagged;
    if (type == 5) return NotificationType.pollAnswered;
    if (type == 6) return NotificationType.quizAnswered;
    if (type == 7) return NotificationType.commentReplied;
    if (type == 8) return NotificationType.postShared;
    if (type == 9) return NotificationType.postLiked;
    if (type == 10) return NotificationType.commentLiked;
    if (type == 11) return NotificationType.repliedInMessage;
    if (type == 12) return NotificationType.repliedInGroup;
    if (type == 13) return NotificationType.sharedInGroup;
    if (type == 14) return NotificationType.sharedInRoom;
    if (type == 15) return NotificationType.invitedToGroup;
    if (type == 16) return NotificationType.acceptedGroupInvite;

    if (type == 17) return NotificationType.madeGroupAdmin;
    if (type == 18) return NotificationType.eventApproved;
    if (type == 19) return NotificationType.attendingEvent;

    if (type == 20) return NotificationType.cancelledEvent;
    if (type == 21) return NotificationType.eventUpdated;
    if (type == 22) return NotificationType.eventReminder;
    if (type == 23) return NotificationType.eventMaxGoal;
    if (type == 24) return NotificationType.challengeCompleted;
    if (type == 25) return NotificationType.challengeUnlocked;
    if (type == 26) return NotificationType.eventDeclined;
    if (type == 27) return NotificationType.postCommented;
  }

  static int setIntType(NotificationType type) {
    switch (type) {
      case NotificationType.requestSent:
        return 0;
        break;
      case NotificationType.requestAccepted:
        return 1;
        break;
      case NotificationType.figureApproved:
        return 2;
        break;
      case NotificationType.imageSent:
        return 3;
        break;
      case NotificationType.tagged:
        return 4;
        break;
      case NotificationType.pollAnswered:
        return 5;
        break;
      case NotificationType.quizAnswered:
        return 6;
        break;
      case NotificationType.commentReplied:
        return 7;
        break;
      case NotificationType.postShared:
        return 8;
        break;
      case NotificationType.postLiked:
        return 9;
        break;
      case NotificationType.commentLiked:
        return 10;
        break;
      case NotificationType.repliedInMessage:
        return 11;
        break;
      case NotificationType.repliedInGroup:
        return 12;
        break;
      case NotificationType.sharedInGroup:
        return 13;
        break;
      case NotificationType.sharedInRoom:
        return 14;
        break;
      case NotificationType.invitedToGroup:
        return 15;
        break;
      case NotificationType.acceptedGroupInvite:
        return 16;
        break;
      case NotificationType.madeGroupAdmin:
        return 17;
        break;
      case NotificationType.eventApproved:
        return 18;
        break;
      case NotificationType.attendingEvent:
        return 19;
        break;
      case NotificationType.cancelledEvent:
        return 20;
        break;
      case NotificationType.eventUpdated:
        return 21;
        break;
      case NotificationType.eventReminder:
        return 22;
        break;
      case NotificationType.eventMaxGoal:
        return 23;
        break;
      case NotificationType.challengeCompleted:
        return 24;
        break;
      case NotificationType.challengeUnlocked:
        return 25;
      case NotificationType.eventDeclined:
        return 26;
      case NotificationType.postCommented:
        return 27;
        break;
      default:
        return -1;
    }
  }
}
