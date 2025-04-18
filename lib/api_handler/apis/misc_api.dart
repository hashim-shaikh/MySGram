import 'package:foap/api_handler/api_wrapper.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/models.dart';

import '../../model/follow_request.dart';
import '../../model/support_request_response.dart';

class MiscApi {
  static getProfileCategoryType(
      {required Function(List<CategoryModel>) resultCallback}) async{
    var url = NetworkConstantsUtil.profileCategoryTypes;

    EasyLoading.show(status: loadingString.tr);
    await ApiWrapper().getApi(url: url).then((result) {
      EasyLoading.dismiss();
      if (result?.success == true) {
        var items = result!.data['profileCategoryType'];
        resultCallback(List<CategoryModel>.from(
            items.map((x) => CategoryModel.fromJson(x))));
      }
    });
  }

  static getPolls(
      {required Function(List<PollsModel>) resultCallback}) async{
    var url = NetworkConstantsUtil.getPolls;

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['poll']['items'];
        resultCallback(List<PollsModel>.from(
            items.map((x) => PollsModel.fromJson(x))));
      }
    });
  }

  static postPollAnswer(
      {required int pollId,
        // required int pollQuestionId,
        required int questionOptionId,
        required Function(List<PollsModel>) resultCallback}) async{
    var url = NetworkConstantsUtil.postPoll;

    await ApiWrapper().postApi(url: url, param: {
      "poll_id": pollId.toString(),
      // "poll_question_id": pollQuestionId.toString(),
      "question_option_id": questionOptionId.toString(),
    }).then((response) {
      if (response?.success == true) {
        var result = response!.data['result'];
        var question = result['question'].first;
        question['pollQuestionOption'] = result['questionOption'];

        resultCallback(List<PollsModel>.from(
            [question].map((x) => PollsModel.fromJson(x))));
      }
    });
  }

  static getNotifications(
      {required Function(List<NotificationModel>, APIMetaData)
          resultCallback}) async {
    var url = NetworkConstantsUtil.getNotifications;

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['notification']['items'];
        resultCallback(
            List<NotificationModel>.from(
                items.map((x) => NotificationModel.fromJson(x))),
            APIMetaData.fromJson(result.data['notification']['_meta']));
      }
    });
  }

  static updateNotificationSettings(
      {required String likesNotificationStatus,
      required String commentNotificationStatus,
      required VoidCallback resultCallback}) async {
    var url = NetworkConstantsUtil.notificationSettings;
    await ApiWrapper().postApi(url: url, param: {
      "like_push_notification_status": likesNotificationStatus,
      "comment_push_notification_status": commentNotificationStatus
    }).then((result) {
      if (result?.success == true) {}
    });
  }

  static getSettings({required Function(SettingModel) resultCallback}) async {
    var url = NetworkConstantsUtil.getSettings;

    await ApiWrapper().getApiWithoutToken(url: url).then((result) {
      if (result?.success == true) {
        var setting = result!.data['setting'];
        resultCallback(SettingModel.fromJson(setting));
      }
    });
  }

  static sendSupportRequest(
      {required String name,
      required String email,
      required String phone,
      required String message}) async {
    var url = NetworkConstantsUtil.submitRequest;
    dynamic param = {
      "name": name,
      "email": email,
      "phone": phone,
      "request_message": message
    };
    await ApiWrapper().postApi(url: url, param: param).then((result) {
      if (result?.success == true) {}
    });
  }

  static getSupportMessages(
      {required Function(List<SupportRequest>, APIMetaData)
          resultCallback}) async {
    var url = NetworkConstantsUtil.supportRequests;

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        List items = result!.data['supportRequest']['items'] as List;
        resultCallback(items.map((e) => SupportRequest.fromJson(e)).toList(),
            APIMetaData.fromJson(result.data['supportRequest']['_meta']));
      }
    });
  }

  static getSupportMessageView(int id) async {
    var url =
        NetworkConstantsUtil.supportRequestView.replaceAll('id', id.toString());

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {}
    });
  }

  static searchHashtag(
      {required String hashtag,
        required int page,
        required Function(List<Hashtag>, APIMetaData) resultCallback}) async {
    var url = '${NetworkConstantsUtil.searchHashtag}$hashtag&page=$page';

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['results']['items'];
        resultCallback(
            List<Hashtag>.from(items.map((x) => Hashtag.fromJson(x))),
            APIMetaData.fromJson(result.data['results']['_meta']));
      }
    });
  }

  static getFAQ({required Function(List<FAQModel>) resultCallback}) async {
    var url = NetworkConstantsUtil.getFAQs;

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['faq']['items'];

        resultCallback(
            List<FAQModel>.from(items.map((x) => FAQModel.fromJson(x))));
      }
    });
  }

  static Future uploadFile(String filePath,
      {required UploadMediaType type,
      required GalleryMediaType mediaType,
      required Function(String, String) resultCallback}) async {
    EasyLoading.show(status: loadingString.tr);

    await ApiWrapper()
        .uploadFile(
            url: NetworkConstantsUtil.uploadFileImage,
            file: filePath,
            mediaType: mediaType,
            type: type)
        .then((result) {
      EasyLoading.dismiss();
      if (result?.success == true) {
        var items = result!.data['files'] as List<dynamic>;

        bool isProhabited = items.first['isProhabited'];

        if (isProhabited == false) {
          resultCallback(items.first['file'], items.first['fileUrl']);
        } else {
          AppUtil.showToast(
              message: thisContentNotAllowedString.tr, isSuccess: false);
        }
      }
    });
  }


  static getFollowRequests(
      {required int page,
        required Function(List<FollowRequestModel>, APIMetaData)
        resultCallback}) async {
    var url = '${NetworkConstantsUtil.followRequests}&page=$page';

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['followingRequest']['items'];
        resultCallback(
            List<FollowRequestModel>.from(
                items.map((x) => FollowRequestModel.fromJson(x))),
            APIMetaData.fromJson(result.data['followingRequest']['_meta']));
      }
    });
  }

  static acceptFollowRequest({required int userId}) async {
    var url = NetworkConstantsUtil.acceptFollowRequestString;

    await ApiWrapper().postApi(
        url: url, param: {"user_id": userId.toString()}).then((result) {});
  }

  static declineFollowRequest({required int userId}) async {
    var url = NetworkConstantsUtil.declineFollowRequestString;

    await ApiWrapper().postApi(
        url: url, param: {"user_id": userId.toString()}).then((result) {});
  }


  static getNotificationInfo(
      {required Function(int) resultCallback}) async {
    var url = NetworkConstantsUtil.notificationInformation;

    await ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var count = result!.data['unread_notification'];
        resultCallback(count);
      }
    });
  }

  static markNotificationAsRead(
      {required int id, required Function() resultCallback}) async {
    var url = NetworkConstantsUtil.markNotificationAsRead;

    await ApiWrapper().postApi(url: url, param: {
      "id": id,
      "is_read_all": 0

      /// for single send 0, send 1 to all as read
    }).then((result) {
      if (result?.success == true) {
        resultCallback();
      }
    });
  }
}
