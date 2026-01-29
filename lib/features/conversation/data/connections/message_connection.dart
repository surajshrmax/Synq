import 'dart:async';
import 'dart:convert';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

class MessageConnection {
  late HubConnection hubConnection;
  final StreamController<MessageModel> _messageController =
      StreamController.broadcast();
  Stream<MessageModel> get messages => _messageController.stream;

  Future<void> buildConnection(Future<String?> token) async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://192.168.135.74:5213/messageHub",
          options: HttpConnectionOptions(accessTokenFactory: () async => (await token)!),
        )
        .withAutomaticReconnect()
        .build();
  }

  Future<void> startConnection() async {
    hubConnection.onclose(({error}) {
      print(error);
    });

    hubConnection.on("RecieveMessage", (args) {
      if (args != null && args.isNotEmpty) {
        final dynamic raw = args[0];

        MessageModel message;

        if (raw is Map<String, dynamic>) {
          message = MessageModel.fromJson(raw);
        } else if (raw is String) {
          message = MessageModel.fromJson(jsonDecode(raw));
        } else {
          print('unknown message type');
          return;
        }

        _messageController.add(message);
      }
    });

    try {
      await hubConnection.start();
      print("connected");
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(String id, IdType type, String content) async {
    await hubConnection.invoke(
      "SendMessage",
      args: [
        {"id": id, "type": type.index, "content": content},
      ],
    );
  }
}
