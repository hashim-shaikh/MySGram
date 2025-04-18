import 'package:foap/controllers/notification/notifications_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/setting_imports.dart';
import 'package:foap/screens/home_feed/story_uploader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_polls/flutter_polls.dart';
import '../../components/post_card/post_card.dart';
import '../../controllers/post/add_post_controller.dart';
import '../../controllers/live/agora_live_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../model/live_model.dart';
import '../../model/post_model.dart';
import '../../segmentAndMenu/horizontal_menu.dart';
import '../post/content_creator_view.dart';
import '../story/story_updates_bar.dart';
import '../story/story_viewer.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  HomeFeedState createState() => HomeFeedState();
}

class HomeFeedState extends State<HomeFeedScreen> {
  final HomeController _homeController = Get.find();
  final AddPostController _addPostController = Get.find();
  final AgoraLiveController _agoraLiveController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final SettingsController _settingsController = Get.find();
  final NotificationController _notificationController = Get.find();

  final _controller = ScrollController();

  String? selectedValue;
  int pollFrequencyIndex = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(isRecent: true);
      _homeController.loadQuickLinksAccordingToSettings();
    });

    _notificationController.getNotificationInfo();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
        } else {
          loadData(isRecent: false);
        }
      }
    });
  }

  loadMore({required bool? isRecent}) {
    loadPosts(isRecent);
  }

  refreshData() {
    _homeController.clear();
    loadData(isRecent: false);
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.clear();
    _homeController.closeQuickLinks();
  }

  loadPosts(bool? isRecent) {
    _homeController.getPosts(
        isRecent: isRecent,
        callback: () {
          _refreshController.refreshCompleted();
        });
  }

  void loadData({required bool? isRecent}) {
    loadPosts(isRecent);
    _homeController.getPolls();
    _homeController.getStories();
  }

  @override
  void didUpdateWidget(covariant HomeFeedScreen oldWidget) {
    loadData(isRecent: false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Container(
                color: AppColorConstants.backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Heading4Text(
                              AppConfigConstants.appName,
                              weight: TextWeight.semiBold,
                            )
                          ],
                        ),
                        const Spacer(),
                        const ThemeIconWidget(
                          ThemeIcon.plus,
                          size: 25,
                        ).ripple(() {
                          Future.delayed(
                            Duration.zero,
                            () => showGeneralDialog(
                                context: Get.context!,
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const ContentCreatorView()),
                          );
                        }),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() => Stack(
                              children: [
                                ThemeIconWidget(
                                  ThemeIcon.notification,
                                  size: 25,
                                  color: AppColorConstants.themeColor,
                                )
                                    .rp(_notificationController
                                                .unreadNotificationCount
                                                .value >
                                            0
                                        ? 15
                                        : 0)
                                    .ripple(() {
                                  Get.to(
                                      () => const NotificationsScreen());
                                }),
                                if (_notificationController
                                        .unreadNotificationCount.value >
                                    0)
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        color:
                                            AppColorConstants.themeColor,
                                        child: Center(
                                          child: Text(
                                            _notificationController
                                                .unreadNotificationCount
                                                .value
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 8,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ).setPadding(
                                              top: 2,
                                              bottom: 2,
                                              left: 4,
                                              right: 4),
                                        ),
                                      ).circular)
                              ],
                            )),
                      ],
                    ).hp(20),
                  ],
                ),
              ),
              Expanded(child: postsView()),
            ],
          ),
        ));
  }

  Widget postsView() {
    return Obx(() {
      return ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.only(top: 25, bottom: 100),
              itemCount: _homeController.posts.length + 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Obx(() =>
                      _homeController.isRefreshingStories.value == true
                          ? const StoryAndHighlightsShimmer()
                          : storiesView());
                } else if (index == 1) {
                  return postingView()
                      .hp(DesignConstants.horizontalPadding);
                } else if (index == 2) {
                  return Obx(() => Column(
                        children: [
                          HorizontalMenuBar(
                              padding: EdgeInsets.only(
                                  left: DesignConstants.horizontalPadding,
                                  right:
                                      DesignConstants.horizontalPadding),
                              onSegmentChange: (segment) {
                                _homeController.categoryIndexChanged(
                                    index: segment,
                                    callback: () {
                                      _refreshController
                                          .refreshCompleted();
                                    });
                              },
                              selectedIndex:
                                  _homeController.categoryIndex.value,
                              menus: [
                                allString.tr,
                                followingString.tr,
                                videosString.tr
                              ]),
                          _homeController.isRefreshingPosts.value == true
                              ? SizedBox(
                                  height: Get.height * 0.9,
                                  child: const HomeScreenShimmer())
                              : _homeController.posts.isEmpty
                                  ? SizedBox(
                                      height: Get.height * 0.5,
                                      child: emptyPost(
                                          title: noPostFoundString.tr,
                                          subTitle:
                                              followFriendsToSeeUpdatesString
                                                  .tr),
                                    )
                                  : Container()
                        ],
                      ));
                } else {
                  PostModel model = _homeController.posts[index - 3];

                  return PostCard(
                    model: model,
                    removePostHandler: () {
                      _homeController.removePostFromList(model);
                    },
                    blockUserHandler: () {
                      _homeController.removeUsersAllPostFromList(model);
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                if (_settingsController.setting.value?.enablePolls ==
                    true) {
                  return polls(index);
                } else {
                  return const SizedBox(
                    height: 0,
                  );
                }
              })
          .addPullToRefresh(
              refreshController: _refreshController,
              enablePullUp: false,
              enablePullDown: true,
              onRefresh: refreshData,
              onLoading: () {});
    });
  }

  Widget postingView() {
    return Obx(() => _addPostController.postingStatus.value ==
            PostingStatus.posting
        ? Container(
            height: 55,
            color: AppColorConstants.cardColor,
            child: Row(
              children: [
                _addPostController.postingMedia.isNotEmpty &&
                        _addPostController.postingMedia.first.mediaType !=
                            GalleryMediaType.gif
                    ? _addPostController.postingMedia.first.thumbnail !=
                            null
                        ? Image.memory(
                            _addPostController
                                .postingMedia.first.thumbnail!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ).round(5)
                        : _addPostController
                                    .postingMedia.first.mediaType ==
                                GalleryMediaType.photo
                            ? Image.file(
                                _addPostController
                                    .postingMedia.first.file!,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ).round(5)
                            // : BodyLargeText(_addPostController.postingTitle)
                            : Container()
                    // : BodyLargeText(_addPostController.postingTitle),
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                Heading5Text(
                  _addPostController.isErrorInPosting.value
                      ? postFailedString.tr
                      : postingString.tr,
                ),
                const Spacer(),
                _addPostController.isErrorInPosting.value
                    ? Row(
                        children: [
                          Heading5Text(
                            discardString.tr,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.discardFailedPost();
                          }),
                          const SizedBox(
                            width: 20,
                          ),
                          Heading5Text(
                            retryString.tr,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.retryPublish();
                          }),
                        ],
                      )
                    : Container()
              ],
            ).hP8,
          ).backgroundCard(radius: 10).bp(20)
        : Container());
  }

  Widget storiesView() {
    return SizedBox(
      height: 110,
      child: GetBuilder<HomeController>(
          init: _homeController,
          builder: (ctx) {
            return StoryUpdatesBar(
              stories: _homeController.stories,
              liveUsers: _homeController.liveUsers,
              addStoryCallback: () {
                openStoryUploader();
              },
              viewStoryCallback: (story) {
                Get.to(() => StoryViewer(
                      story: story,
                      storyDeleted: () {
                        _homeController.getStories();
                      },
                    ));
              },
              joinLiveUserCallback: (user) {
                LiveModel live = LiveModel();
                live.channelName = user.liveCallDetail!.channelName;
                live.mainHostUserDetail = user;
                live.token = user.liveCallDetail!.token;
                live.id = user.liveCallDetail!.id;
                _agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
            ).vP16;
          }),
    ).hp(DesignConstants.horizontalPadding);
  }

  polls(int index) {
    int postIndex = index > 2 ? index - 3 : 0;
    if (postIndex % pollFrequencyIndex == 0 && postIndex != 0) {
      int pollIndex = (postIndex ~/ pollFrequencyIndex) - 1;
      if (_homeController.polls.length > pollIndex) {
        return Container(
          color: AppColorConstants.cardColor,
          child: FlutterPolls(
            pollId: _homeController.polls[pollIndex].id.toString(),
            hasVoted: _homeController.polls[pollIndex].isVote! > 0,
            userVotedOptionId: _homeController.polls[pollIndex].isVote! > 0
                ? _homeController.polls[pollIndex].isVote.toString()
                : null,
            onVoted: (PollOption pollOption, int newTotalVotes) async {
              await Future.delayed(const Duration(seconds: 1));
              _homeController.postPollAnswer(
                  _homeController.polls[pollIndex].id!,
                  int.parse(pollOption.id!));

              /// If HTTP status is success, return true else false
              return true;
            },
            pollEnded: false,
            pollOptionsSplashColor: Colors.white,
            votedProgressColor: Colors.grey.withOpacity(0.3),
            votedBackgroundColor: Colors.grey.withOpacity(0.2),
            votesTextStyle: TextStyle(fontSize: FontSizes.b2),
            votedPercentageTextStyle:
                TextStyle(fontSize: FontSizes.b2).copyWith(
              color: Colors.black,
            ),
            votedCheckmark: const Icon(
              Icons.check_circle,
              color: Colors.black,
            ),
            pollTitle: Align(
              alignment: Alignment.centerLeft,
              child: BodyLargeText(
                _homeController.polls[pollIndex].title ?? "",
                weight: TextWeight.medium,
              ),
            ),
            pollOptions: List<PollOption>.from(
              (_homeController.polls[pollIndex].pollOptions ?? []).map(
                (option) {
                  var a = PollOption(
                    id: option.id.toString(),
                    title: BodyLargeText(option.title ?? '',
                        weight: TextWeight.medium),
                    votes: option.totalOptionVoteCount ?? 0,
                  );
                  return a;
                },
              ),
            ),
          ).p16,
        ).round(15).p16;
      } else {
        return const SizedBox(
          height: 0,
        );
      }
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }
}
