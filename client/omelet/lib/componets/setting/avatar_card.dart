import 'package:flutter/material.dart';
import 'package:omelet/componets/message/avatar.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/utils/load_local_info.dart';


class AvatarCard extends StatelessWidget {
  const AvatarCard({
    Key? key,
  }) : super(key: key);
  
  

  @override
  Widget build(BuildContext context) {
    print(ourUid);
    return FutureBuilder<String>(
      future: loadUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Row(
              children: [
                const Avatar.large(url:'https://3b7a-125-227-227-205.ngrok-free.app/pfp/551338674692820992.png'),
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
                    const Text(
                      'Youtuber channel',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        } else {
          return const  CircularProgressIndicator();
        }
      },
    );
  }
}

