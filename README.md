# Omelet.im
蛋餅 Omelet - 端對端加密即時通訊軟體

```
Omelet.im
├─ backend
│  ├─ .DS_Store
│  ├─ .eslintrc.json
│  ├─ README.md
│  ├─ api
│  │  ├─ debug.js
│  │  ├─ get
│  │  │  ├─ downloadImage.js
│  │  │  ├─ downloadPreKeyBundle.js
│  │  │  ├─ getAvailableOpkIndex.js
│  │  │  ├─ getDeviceIds.js
│  │  │  ├─ getFriendList.js
│  │  │  ├─ getFriendRequest.js
│  │  │  ├─ getSelfOpkStatus.js
│  │  │  ├─ getSelfSpkStatus.js
│  │  │  ├─ getUnreadMsg.js
│  │  │  └─ getUserPublicInfo.js
│  │  ├─ notFound.js
│  │  └─ post
│  │     ├─ cancelFriendRequest.js
│  │     ├─ deleteMyAccount.js
│  │     ├─ getTranslatedSentence.js
│  │     ├─ login.js
│  │     ├─ register.js
│  │     ├─ removeFriend.js
│  │     ├─ replyFriendRequest.js
│  │     ├─ resetPassword.js
│  │     ├─ sendFriendRequest.js
│  │     ├─ updateOpk.js
│  │     ├─ updatePfp.js
│  │     ├─ updateSpk.js
│  │     ├─ uploadImg.js
│  │     └─ uploadPreKeyBundle.js
│  ├─ aws_server.js
│  ├─ config
│  │  ├─ cf.crt
│  │  └─ cf.key
│  ├─ controller
│  │  ├─ authController.js
│  │  ├─ friendController.js
│  │  ├─ msgController.js
│  │  └─ preKeyBundleController.js
│  ├─ img
│  ├─ model
│  │  ├─ friendRequestModel.js
│  │  ├─ mongoose.js
│  │  ├─ msgModel.js
│  │  ├─ preKeyBundleModel.js
│  │  ├─ unverifiedUserModel.js
│  │  └─ verifiedUserModel.js
│  ├─ package-lock.json
│  ├─ package.json
│  ├─ pfp
│  ├─ server.js
│  ├─ utils
│  │  ├─ email.js
│  │  ├─ eventEmitter.js
│  │  ├─ jwt.js
│  │  ├─ passwordHelper.js
│  │  ├─ rateLimit.js
│  │  ├─ snowflakeId.js
│  │  └─ socket.js
│  └─ view
│     ├─ confirm-delete-my-account.html
│     ├─ confirm-register-email-failed.html
│     ├─ confirm-register-email-success.html
│     ├─ confirm-reset-email.html
│     ├─ confirm-reset-email.js
│     ├─ home.html
│     ├─ home.js
│     ├─ icon.png
│     └─ qr.png
├─ client
│  ├─ .DS_Store
│  └─ omelet
│     ├─ OmeletIcon.png
│     ├─ README.md
│     ├─ lib
│     │  ├─ README.md
│     │  ├─ api
│     │  │  ├─ debug_reset_prekeybundle_and_unread_msg.dart
│     │  │  ├─ get
│     │  │  │  ├─ download_pre_key_bundle_api.dart
│     │  │  │  ├─ get_available_opk_index_api.dart
│     │  │  │  ├─ get_device_ids_api.dart
│     │  │  │  ├─ get_friend_list_api.dart
│     │  │  │  ├─ get_friend_request_api.dart
│     │  │  │  ├─ get_self_opk_status_api.dart
│     │  │  │  ├─ get_self_spk_status_api.dart
│     │  │  │  ├─ get_unread_msg_api.dart
│     │  │  │  └─ get_user_public_info_api.dart
│     │  │  └─ post
│     │  │     ├─ get_translated_sentence_api.dart
│     │  │     ├─ login_api.dart
│     │  │     ├─ remove_friend_api.dart
│     │  │     ├─ reply_friend_request_api.dart
│     │  │     ├─ reset_password_api.dart
│     │  │     ├─ send_friend_request_api.dart
│     │  │     ├─ signup_api.dart
│     │  │     ├─ update_opk_api.dart
│     │  │     ├─ update_pfp_api.dart
│     │  │     ├─ update_spk_api.dart
│     │  │     ├─ upload_img_api.dart
│     │  │     └─ upload_pre_key_bundle_api.dart
│     │  ├─ components
│     │  │  ├─ Screen
│     │  │  │  └─ frosted_appbr.dart
│     │  │  ├─ alert
│     │  │  │  └─ alert_msg.dart
│     │  │  ├─ button
│     │  │  │  ├─ on_select_image_btn_pressed.dart
│     │  │  │  ├─ on_send_msg_btn_pressed.dart
│     │  │  │  └─ on_update_pfp_btn_pressed.dart
│     │  │  ├─ message
│     │  │  │  ├─ avatar.dart
│     │  │  │  ├─ avatar_user.dart
│     │  │  │  └─ glow_bar.dart
│     │  │  └─ setting
│     │  │     ├─ avatar_card.dart
│     │  │     └─ setting_title.dart
│     │  ├─ developer
│     │  │  ├─ developer_page.dart
│     │  │  └─ test_ping_page.dart
│     │  ├─ main.dart
│     │  ├─ models
│     │  │  ├─ message_data.dart
│     │  │  └─ setting.dart
│     │  ├─ notify
│     │  │  └─ notify.dart
│     │  ├─ pages
│     │  │  ├─ friends_page
│     │  │  │  ├─ friends_add_page.dart
│     │  │  │  └─ friends_list_page.dart
│     │  │  ├─ login_signup
│     │  │  │  ├─ forget_page.dart
│     │  │  │  ├─ forget_validator_page.dart
│     │  │  │  ├─ loading_page.dart
│     │  │  │  ├─ login_page.dart
│     │  │  │  └─ sign_up_page.dart
│     │  │  ├─ message
│     │  │  │  ├─ chat_room_page.dart
│     │  │  │  └─ multi_screen
│     │  │  │     └─ multi_chat_room.dart
│     │  │  ├─ message_list_page.dart
│     │  │  ├─ nav_bar_control_page.dart
│     │  │  ├─ notification_page
│     │  │  │  └─ notification_page.dart
│     │  │  └─ setting
│     │  │     └─ setting_page.dart
│     │  ├─ signal_protocol
│     │  │  ├─ decrypt_msg.dart
│     │  │  ├─ encrypt_msg.dart
│     │  │  ├─ encrypt_pre_key_signal_message.dart
│     │  │  ├─ encrypt_signal_message.dart
│     │  │  ├─ generate_and_store_key.dart
│     │  │  ├─ pre_key_bundle_converter.dart
│     │  │  ├─ safe_identity_store.dart
│     │  │  ├─ safe_opk_store.dart
│     │  │  ├─ safe_session_store.dart
│     │  │  ├─ safe_signal_protocol_store.dart
│     │  │  └─ safe_spk_store.dart
│     │  ├─ storage
│     │  │  ├─ safe_account_store.dart
│     │  │  ├─ safe_config_store.dart
│     │  │  ├─ safe_device_id_store.dart
│     │  │  ├─ safe_msg_store.dart
│     │  │  ├─ safe_notify_store.dart
│     │  │  └─ safe_util_store.dart
│     │  ├─ theme
│     │  │  ├─ theme_constants.dart
│     │  │  └─ theme_provider.dart
│     │  └─ utils
│     │     ├─ check_device_id.dart
│     │     ├─ check_opk_status.dart
│     │     ├─ check_spk_status.dart
│     │     ├─ check_unread_msg.dart
│     │     ├─ check_unread_notify.dart
│     │     ├─ generate_random_filename.dart
│     │     ├─ get_friends_list.dart
│     │     ├─ helpers.dart
│     │     ├─ server_uri.dart
│     │     └─ timstamp.dart
│     ├─ pubspec.lock
│     ├─ pubspec.yaml
│     ├─ test
│     │  └─ widget_test.dart
│     └─ web
│        ├─ favicon.png
│        ├─ icons
│        │  ├─ Icon-192.png
│        │  ├─ Icon-512.png
│        │  ├─ Icon-maskable-192.png
│        │  └─ Icon-maskable-512.png
│        └─ manifest.json
└─ special_feature
   └─ assistive_chatbot
      ├─ assisted_chat.js
      ├─ package-lock.json
      ├─ package.json
      └─ translate.js

```