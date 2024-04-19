import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omelet/api/post/remove_friend_api.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/pages/friends_page/friends_add_page.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/utils/get_friends_list.dart';
import 'package:omelet/storage/safe_util_store.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key, required this.ourUid});
  final String ourUid;
  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  late Future<List<Map<String, dynamic>>> _friendsListFuture;

  @override
  void initState() {
    super.initState();
    _friendsListFuture = getFriendsList(); // 獲取好友列表的Future
  }

  Future<void> _handleRefreshFriend() async {
    setState(() {
      _friendsListFuture = getFriendsList(); // Reload friend list
    });
    await _friendsListFuture; // Wait for the friend list to be reloaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(ourUid:widget.ourUid),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        Color.fromARGB(255, 240, 118, 36)),
                  ); // 正在加載顯示進度指示器
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // 如果出現錯誤，顯示錯誤消息
                }
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: _handleRefreshFriend,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child:
                          FriendsList(friends: snapshot.data!, ourUid: widget.ourUid,), // 如果有數據，顯示好友列表
                    ),
                  );
                } else {
                  return const Text('哭沒朋友，請點擊右上角加好友吧～'); // 如果沒有數據，顯示沒有數據消息
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FriendsList extends StatelessWidget {
  final List<Map<String, dynamic>> friends;

  FriendsList({Key? key, required this.friends, required this.ourUid}) : super(key: key);
  SafeUtilStore safeUtilStore = SafeUtilStore();
  final String ourUid;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        // 获取当前好友信息
        Map<String, dynamic> friend = friends[index];
        String? pfpUrl;
        // 提取好友的用户名、头像 URL 和 UID
        String username = friend['data']['username'];
        if (friend['data']['pfp'] != null) {
          pfpUrl = friend['data']['pfp'];
        } else {
          pfpUrl = null;
        }
        String userUid = friend['data']['uid'];
        Widget avatarWidget = pfpUrl == null
            ? const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.egg_alt_rounded,
                  size: 43,
                  color: Color.fromARGB(255, 238, 108, 33),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.sm(
                  url: pfpUrl,
                ),
              );
        Future<void> onDeletedFriends(String userUid) async {
          await removeFriendApi(userUid);
          print('[friends_list_page.dart]已刪除好友$userUid');
        }

        return Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onDeletedFriends(userUid),
                backgroundColor: const Color.fromARGB(255, 225, 106, 20),
                icon: Icons.delete,
                label: 'Delet Friend',
              )
            ],
          ),
          child: ListTile(
            title: Row(
              children: [
                avatarWidget,
                const SizedBox(width: 30),
                Text(
                  username,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    letterSpacing: 0.2,
                    wordSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            onTap: () async {
              //跳轉至該用戶的聊天頁面
              await safeUtilStore.writeIsSend(friend['data']['uid'], true);
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatRoomPage(ourUid:ourUid, friendsUid: friend['data']['uid'],)));
            },
          ),
        );
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  //搜尋框、搜尋好友、添加好友列表
  const SearchBar({super.key, required this.ourUid});
  final String ourUid;
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: 'Search in Friends',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              //搜尋好友Button
              // final query = _searchController.text;
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                // 跳轉至添加好有頁面(FriendsAddPage)
                context,
              MaterialPageRoute(builder: (context) => FriendsAddPage(ourUid: widget.ourUid,)),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
