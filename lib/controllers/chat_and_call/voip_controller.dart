import 'package:flutter_callkit_incoming/entities/call_event.dart'
    as call_event;
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart'
    as callkit;
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/call_model.dart';
import 'agora_call_controller.dart';

class CallData {
  String uuid;
  int id;
  String callerName;
  int callerId;
  String? callerImage;
  String channelName;
  String token;
  int type;

  CallData({
    required this.uuid,
    required this.id,
    required this.callerName,
    required this.callerId,
    this.callerImage,
    required this.channelName,
    required this.token,
    required this.type,
  });

  factory CallData.fromJson(Map<String, dynamic> json) => CallData(
        uuid: json["id"],
        callerName: json["nameCaller"],
        type: json["type"],
        id: json["extra"]["id"],
        callerId: json["extra"]["callerId"],
        callerImage: json["extra"]["callerImage"],
        channelName: json["extra"]["channelName"],
        token: json["extra"]["token"],
      );
}

class VoipController extends GetxController {
  final AgoraCallController agoraCallController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();
  bool? callEndedByMe;

  clear() {
    callEndedByMe = null;
  }

  endCall(Call call) {
    callEndedByMe = true;
    callkit.FlutterCallkitIncoming.endCall(call.uuid);
  }

  declinedByOpponent(Call call) {
    // callEndedByMe = false;
    callkit.FlutterCallkitIncoming.endCall(call.uuid);
  }

  endCallByOpponent(Call call) {
    callEndedByMe = false;
    callkit.FlutterCallkitIncoming.endCall(call.uuid);
  }

  listenerSetup() {
    callkit.FlutterCallkitIncoming.onEvent.listen((event) {
      print('event!.event ${event!.event}');
      switch (event!.event) {
        case call_event.Event.actionCallIncoming:
          break;
        case call_event.Event.actionCallStart:
          break;
        case call_event.Event.actionCallAccept:
          Future.delayed(const Duration(seconds: 1), () {
            CallData callData = CallData.fromJson(event.body);

            UserModel opponent = UserModel();
            opponent.id = callData.callerId;
            opponent.userName = callData.callerName;
            opponent.picture = callData.callerImage;

            Call call = Call(
                uuid: callData.uuid,
                callId: callData.id,
                channelName: callData.channelName,
                isOutGoing: false,
                token: callData.token,
                callType: callData.type == 0 ? 1 : 2,
                opponent: opponent);
            agoraCallController.initiateAcceptCall(call: call);
            clear();
          });

          break;
        case call_event.Event.actionCallDecline:
          CallData callData = CallData.fromJson(event.body);

          Call call = Call(
              uuid: event.body['id'],
              channelName: '',
              isOutGoing: false,
              opponent: UserModel(),
              token: '',
              callType: 0,
              callId: 0);
          if (callData.callerId != _userProfileManager.user.value!.id) {
            //call made by me
            agoraCallController.declineIncomingCall(call: call);
          }
          clear();
          break;
        case call_event.Event.actionCallEnded:
          Call call = Call(
              uuid: event.body['id'],
              channelName: '',
              isOutGoing: false,
              opponent: UserModel(),
              token: '',
              callType: 0,
              callId: 0);

          if (callEndedByMe == true) {
          } else if (callEndedByMe == false) {
            agoraCallController.receivedEndCallNotification(call);
          } else {
            // agoraCallController.onCallEnd(call);
          }

          clear();

          break;
        case call_event.Event.actionCallTimeout:
          Call call = Call(
              uuid: event.body['id'],
              channelName: '',
              isOutGoing: false,
              opponent: UserModel(),
              token: '',
              callType: 0,
              callId: 0);
          // CallData callData = CallData.fromJson(event.body);
          // if (callData.callerId != _userProfileManager.user.value?.id &&
          //     _userProfileManager.user.value?.id != null) {
          // Call call = Call(
          //     uuid: callData.uuid,
          //     channelName: callData.channelName,
          //     isOutGoing: false,
          //     opponent: UserModel(),
          //     token: callData.token,
          //     callType: callData.type == 0 ? 1 : 2,
          //     callId: callData.id);
          // var params = <String, dynamic>{'id': event.body['id']};
          // callkit.FlutterCallkitIncoming.endCall(event.body['id']);
          agoraCallController.declineIncomingCall(call: call);
          clear();
          // }
          break;
        case call_event.Event.actionCallCallback:
          break;
        case call_event.Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case call_event.Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case call_event.Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case call_event.Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case call_event.Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        // case call_event.Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
        //   // TODO: only iOS
        //   break;
        default:
          break;
      }
    });
  }

  outGoingCall(Call call) async {
    CallKitParams params = CallKitParams(
        id: call.uuid,
        nameCaller: call.opponent.userName,
        handle: call.channelName,
        type: call.callType == 1 ? 0 : 1,
        extra: <String, dynamic>{
          'id': call.callId,
          'callerId': _userProfileManager.user.value!.id,
          'callerImage': _userProfileManager.user.value!.picture,
          'channelName': call.channelName,
          'token': call.token
        },
        ios: const IOSParams(handleType: 'generic'));

    await callkit.FlutterCallkitIncoming.startCall(params);
    clear();
  }

// missCall(Call call) async {
//   CallKitParams params = CallKitParams(
//       id: call.uuid,
//       nameCaller: call.opponent.userName,
//       handle: call.channelName,
//       type: call.callType == 1 ? 0 : 1,
//       extra: <String, dynamic>{
//         'id': call.callId,
//         'callerId': _userProfileManager.user.value!.id,
//         'callerImage': _userProfileManager.user.value!.picture,
//         'channelName': call.channelName,
//         'token': call.token
//       },
//       ios: const IOSParams(handleType: 'generic'));
//
//   await callkit.FlutterCallkitIncoming.showMissCallNotification(params);
// }
//
// endAllCalls() async {
//   await callkit.FlutterCallkitIncoming.endAllCalls();
// }
}
