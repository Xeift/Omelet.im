import 'package:flutter/material.dart';
import 'package:omelet/pages/friends_page/friends_add_page.dart';
import 'package:omelet/utils/get_friends_list.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final List<String> _friends = []; // 創建好友的空list

  @override
  void initState() {//初始化
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    //實現加載好友的功能
    setState(() {
      //假得好以列表，測試使用
      _friends.addAll(['Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3,Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3','Friend 1', 'Friend 2', 'Friend 3']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SearchBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: FriendsList(friends: _friends),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {//搜尋框、搜尋好友、添加好友列表
  const SearchBar({super.key});

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
            onPressed: () {//搜尋好友Button
              final query = _searchController.text;
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(//挑轉至添加好有頁面(FriendsAddPage)
                context,
                MaterialPageRoute(builder: (context) => const FriendsAddPage()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}


class FriendsList extends StatelessWidget {
  final List<String> friends;

  const FriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,//好友數量
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(friends[index]),//顯示好友頭像、名稱
          onTap: () {
            //TODO:跳轉好友聊天室，須有好友UID
    
          },
        );
      },
    );
  }
}