import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:omelet/api/get/get_friend_list_api.dart';
import 'package:omelet/pages/friends_page/friends_add_page.dart';
import 'package:omelet/utils/get_friends_list.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SearchBar(),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // 正在加載顯示進度指示器
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // 如果出現錯誤，顯示錯誤消息
                }
                if (snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: FriendsList(friends: snapshot.data!), // 如果有數據，顯示好友列表
                  );
                }
                return const Text('No data available'); // 如果沒有數據，顯示沒有數據消息
              },
            ),
          ],
        ),
      ),
    );
  }
}


class FriendsList extends StatelessWidget {
  final List<Map<String, dynamic>> friends; // 添加 friends 参数

  const FriendsList({Key? key, required this.friends}) : super(key: key); // 初始化 friends 参数

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: Column(
      //   children: [
      //     for (var friend in friends) // 遍历好友列表并显示
      //       ListTile(
      //         title: Text(friend['name']), // 假设好友对象中有名为 'name' 的字段
      //         // onTap: () {}, // 如果需要，可以添加跳转到聊天室的操作
      //       ),
      //   ],
      // ),
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

