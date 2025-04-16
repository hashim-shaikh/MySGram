import 'package:foap/helper/imports/common_import.dart';

int postTypeValueFrom(PostType postType) {
  switch (postType) {
    case PostType.basic:
      return 1;
    case PostType.competition:
      return 2;
    case PostType.club:
      return 3;
    case PostType.reel:
      return 4;
    case PostType.reshare:
      return 5;
  }
}

PostContentType postContentTypeValueFrom(int contentType) {
  switch (contentType) {
    case 1:
      return PostContentType.text;
    case 2:
      return PostContentType.media;
    case 3:
      return PostContentType.location;
    case 4:
      return PostContentType.poll;
    case 5:
      return PostContentType.competitionAdded;

    case 9:
      return PostContentType.competitionResultDeclared;
    case 13:
      return PostContentType.club;
    case 14:
      return PostContentType.openGroup;
  }
  return PostContentType.text;
}

int postContentTypeIdFrom(PostContentType contentType) {
  switch (contentType) {
    case PostContentType.text:
      return 1;
    case PostContentType.media:
      return 2;
    case PostContentType.location:
      return 3;
    case PostContentType.poll:
      return 4;
    case PostContentType.competitionAdded:
      return 5;

    case PostContentType.competitionResultDeclared:
      return 9;

    case PostContentType.club:
      return 13;
    case PostContentType.openGroup:
      return 14;
  }
}

int mediaTypeIdFromMediaType(GalleryMediaType type) {
  switch (type) {
    case GalleryMediaType.photo:
      return 1;
    case GalleryMediaType.video:
      return 2;
    case GalleryMediaType.audio:
      return 3;
    case GalleryMediaType.gif:
      return 4;
    default:
      return 1;
  }
}

int itemViewSourceToId(ItemViewSource source) {
  switch (source) {
    case ItemViewSource.normal:
      return 1;
    case ItemViewSource.promotion:
      return 2;
  }
}

int userViewSourceTypeToId(UserViewSourceType source) {
  switch (source) {
    case UserViewSourceType.post:
      return 1;
    case UserViewSourceType.reel:
      return 2;
    case UserViewSourceType.story:
      return 2;
  }
}

PaymentType paymentTypeFromId(int id) {
  switch (id) {
    case 3:
      return PaymentType.withdrawal;

    case 6:
      return PaymentType.gift;
    case 7:
      return PaymentType.redeemCoin;
  }
  return PaymentType.gift;
}

String paymentTypeStringFromId(PaymentType type) {
  switch (type) {
    case PaymentType.withdrawal:
      return withdrawalString.tr;
    case PaymentType.gift:
      return giftsReceivedString.tr;
    case PaymentType.redeemCoin:
      return redeemString.tr;
  }
}

PaymentMode paymentModeFromId(int id) {
  switch (id) {
    case 1:
      return PaymentMode.inAppPurchase;
    case 2:
      return PaymentMode.paypal;
    case 3:
      return PaymentMode.wallet;
    case 4:
      return PaymentMode.stripe;
    case 5:
      return PaymentMode.razorpay;
    case 9:
      return PaymentMode.flutterWave;
  }
  return PaymentMode.inAppPurchase;
}

TransactionType transactionTypeFromId(int id) {
  if (id == 1) {
    return TransactionType.credit;
  }
  return TransactionType.debit;
}

int messageTypeId(MessageContentType type) {
  switch (type) {
    case MessageContentType.text:
      return 1;
    case MessageContentType.photo:
      return 2;
    case MessageContentType.video:
      return 3;
    case MessageContentType.audio:
      return 4;
    case MessageContentType.gif:
      return 5;
    case MessageContentType.sticker:
      return 6;
    case MessageContentType.contact:
      return 7;
    case MessageContentType.location:
      return 8;
    case MessageContentType.reply:
      return 9;
    case MessageContentType.forward:
      return 10;
    case MessageContentType.post:
      return 11;
    case MessageContentType.story:
      return 12;
    case MessageContentType.drawing:
      return 13;
    case MessageContentType.profile:
      return 14;
    case MessageContentType.group:
      return 15;
    case MessageContentType.file:
      return 16;
    case MessageContentType.textReplyOnStory:
      return 17;
    case MessageContentType.reactedOnStory:
      return 18;
    case MessageContentType.groupAction:
      return 100;
    case MessageContentType.gift:
      return 200;
  }
}

int uploadMediaTypeId(UploadMediaType type) {
  switch (type) {
    case UploadMediaType.storyOrHighlights:
      return 3;
    case UploadMediaType.chat:
      return 5;
    case UploadMediaType.club:
      return 5;
    case UploadMediaType.post:
      return 7;
    case UploadMediaType.verification:
      return 12;
  }
  return 1;
}

int liveViewerRole(LiveUserRole role) {
  switch (role) {
    case LiveUserRole.viewer:
      return 2;
    case LiveUserRole.moderator:
      return 3;
    case LiveUserRole.host:
      return 1;
  }
}


SMSGateway smsGatewayType(int id) {
  switch (id) {
    case 1:
      return SMSGateway.twilio;
    case 2:
      return SMSGateway.sms91;
    case 3:
      return SMSGateway.firebase;
    default:
      return SMSGateway.twilio;
  }
}

SubscribedStatus subscribedStatusType(int id) {
  switch (id) {
    case 0:
      return SubscribedStatus.notSubscribed;
    case 1:
      return SubscribedStatus.subscribed;
    case 2:
      return SubscribedStatus.expired;
    default:
      return SubscribedStatus.notSubscribed;
  }
}

