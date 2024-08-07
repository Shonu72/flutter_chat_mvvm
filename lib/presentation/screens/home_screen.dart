import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charterer/core/theme/colors.dart';
import 'package:charterer/core/utils/helpers.dart';
import 'package:charterer/data/models/chat_contact_model.dart';
import 'package:charterer/data/models/group_model.dart';
import 'package:charterer/data/models/story_model.dart';
import 'package:charterer/data/models/user_model.dart';
import 'package:charterer/presentation/getx/controllers/auth_controller.dart';
import 'package:charterer/presentation/getx/controllers/chat_controller.dart';
import 'package:charterer/presentation/getx/controllers/story_controller.dart';
import 'package:charterer/presentation/getx/routes/routes.dart';
import 'package:charterer/presentation/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final AuthControlller authcontroller = Get.find<AuthControlller>();
  final StoryController storyController = Get.find<StoryController>();

  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    UserModel? user = await authcontroller.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 34, 51),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 34, 51),
          title: const Text(
            "Messages",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leading: Transform.rotate(
              angle: 360 * math.pi / 180,
              child: IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate(),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              )),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.person_add_alt_1_sharp,
                color: whiteColor,
                size: 32,
              ),
              onPressed: () => Get.toNamed(Routes.createGroup),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.profileScreen, arguments: {
                  'profilePic': currentUser?.profilePic,
                  'name': currentUser?.name,
                  'phoneNumber': currentUser?.phoneNumber,
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                    currentUser?.profilePic ??
                        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Stories",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    File? image =
                                        await Helpers.pickImageFromGallery(
                                            context);
                                    if (image != null) {
                                      Get.toNamed(Routes.confirmStory,
                                          arguments: {
                                            'storyImage': image,
                                          });
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    maxRadius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                        currentUser?.profilePic ?? ''),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      File? image =
                                          await Helpers.pickImageFromGallery(
                                              context);
                                      if (image != null) {
                                        Get.toNamed(Routes.confirmStory,
                                            arguments: {
                                              'storyImage': image,
                                            });
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              currentUser?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: FutureBuilder<List<StoryModel>>(
                            future: storyController.getStories(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                  child: AppText(
                                    text: "No stories available",
                                    color: whiteColor,
                                  ),
                                );
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var storyData = snapshot.data![index];
                                  print(storyData.username);
                                  print(storyData.profilePic);

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 10,
                                      right: 5,
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.storyview,
                                              arguments: {
                                                'allStories': snapshot.data,
                                                'initialIndex': index,
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            maxRadius: 30,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    storyData.profilePic),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          storyData.username,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Conversations",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                    ),
                    Expanded(
                      // conversations list
                      child: Column(
                        children: [
                          StreamBuilder<List<Group>>(
                              stream: chatController.chatGroups(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text('No data'),
                                  );
                                }
                                List<Group> sortedGroups = snapshot.data!
                                  ..sort((a, b) =>
                                      b.timeSent.compareTo(a.timeSent));

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: sortedGroups.length,
                                  itemBuilder: (context, index) {
                                    var groupData = sortedGroups[index];

                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.chatPage,
                                                arguments: {
                                                  'name': groupData.name,
                                                  'uid': groupData.groupId,
                                                  'isGroupChat': true,
                                                  'profilePic':
                                                      groupData.groupPic,
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 4),
                                            child: ListTile(
                                              tileColor: textLightColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              title: Text(
                                                groupData.name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: whiteColor),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Text(
                                                  groupData.lastMessage,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: whiteColor),
                                                ),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  groupData.groupPic,
                                                ),
                                                radius: 30,
                                              ),
                                              trailing: Text(
                                                DateFormat.jm()
                                                    .format(groupData.timeSent),
                                                style: TextStyle(
                                                  color: whiteColor
                                                      .withOpacity(0.7),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                          StreamBuilder<List<ChatContact>>(
                              stream: chatController.chatContacts(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List<ChatContact> sortedChatContacts = snapshot
                                    .data!
                                  ..sort((a, b) =>
                                      b.timeSent.compareTo(a.timeSent));

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: sortedChatContacts.length,
                                  itemBuilder: (context, index) {
                                    var chatContactData =
                                        sortedChatContacts[index];

                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.chatPage,
                                                arguments: {
                                                  'name': chatContactData.name,
                                                  'uid':
                                                      chatContactData.contactId,
                                                  'isGroupChat': false,
                                                  'profilePic': chatContactData
                                                      .profilePic,
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 4),
                                            child: ListTile(
                                              tileColor: textLightColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              title: Text(
                                                chatContactData.name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: whiteColor),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Text(
                                                  chatContactData.lastMessage,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: whiteColor),
                                                ),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  chatContactData.profilePic,
                                                ),
                                                radius: 30,
                                              ),
                                              trailing: Text(
                                                DateFormat.jm().format(
                                                    chatContactData.timeSent),
                                                style: TextStyle(
                                                  color: whiteColor
                                                      .withOpacity(0.7),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class MySearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search...';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "null");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your result display logic here
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
