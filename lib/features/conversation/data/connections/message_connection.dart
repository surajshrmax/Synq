import 'dart:async';
import 'dart:convert';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synq/config/constants.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';

class MessageConnection {
  late HubConnection hubConnection;

  final StreamController<MessageModel> _newMessageController =
      StreamController.broadcast();
  Stream<MessageModel> get messages => _newMessageController.stream;

  final StreamController<String> _deleteMessageController =
      StreamController.broadcast();
  Stream<String> get deletes => _deleteMessageController.stream;

  final StreamController<MessageModel> _updateMessageController =
      StreamController.broadcast();
  Stream<MessageModel> get updates => _updateMessageController.stream;

  Future<void> buildConnection(Future<String?> token) async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          "$serverUrl/messageHub",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => (await token)!,
          ),
        )
        .withAutomaticReconnect()
        .build();
  }

  Future<void> startConnection() async {
    hubConnection.onclose(({error}) {
      print(error);
    });

    hubConnection.on("RecieveMessage", (args) {
      print("GETTING MESSAGE FROM SERVER");
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

        _newMessageController.add(message);
      }
    });

    hubConnection.on("MessageDeleted", (args) {
      if (args != null && args.isNotEmpty) {
        final dynamic id = args[0];
        print("GOT SOMETHING TO DELETE $id");
        _deleteMessageController.add(id);
      }
    });

    hubConnection.on("MessageUpdate", (args) {
      print("GETTING UPDATE REQUEST FROM SERVER");
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

        _updateMessageController.add(message);
      }
    });

    hubConnection.on("UpdateDone", (args) {
      print("GETTING UPDATE REQUEST FROM SERVER");
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

        _updateMessageController.add(message);
      }
    });

    try {
      await hubConnection.start();
      print("connected");
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(
    String id,
    IdType type,
    String content,
    String? replyMessageId,
  ) async {
    await hubConnection.invoke(
      "SendMessage",
      args: [
        {
          "id": id,
          "type": type.index,
          "content": content,
          "replyMessageId": replyMessageId,
        },
      ],
    );
  }

  Future<void> deleteMessage(String id) async {
    await hubConnection.invoke("DeleteMessage", args: [id]);
  }

  Future<void> updateMessage(String id, String content) async {
    await hubConnection.invoke(
      "UpdateMessage",
      args: [
        {"messageId": id, "content": content},
      ],
    );
  }
}
