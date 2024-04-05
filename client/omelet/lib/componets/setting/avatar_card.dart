import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:http/http.dart' as http;

class AvatarCard extends StatelessWidget {
  AvatarCard({
    Key? key,
  }) : super(key: key);

  final String imgUrl = '$serverUri/pfp/$ourUid.png';

  Future<bool> isValidUrl(String url) async {
    if (url.isEmpty) return false; // 確保網址不是空的

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200; // 如果狀態碼是 200，則視為有效的 URL
    } catch (e) {
      return false; // 發生任何異常時都視為無效的 URL
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[setting_page]imgurl:$imgUrl');
    print(ourUid);
    return FutureBuilder<String>(
      future: loadUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return FutureBuilder<bool>(
              future: isValidUrl(imgUrl),
              builder: (context, urlSnapshot) {
                if (urlSnapshot.connectionState == ConnectionState.done) {
                  final bool isUrlValid = urlSnapshot.data ?? false;
                  return Row(
                    children: [
                      if (isUrlValid) // 判斷是否為有效的 URL
                        Avatar.large(url: imgUrl) // 如果是有效的 URL，顯示圖片
                      else
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 55,
                        ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
