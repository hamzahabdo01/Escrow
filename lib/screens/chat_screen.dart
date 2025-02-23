import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:escrow_app/services/auth_service.dart';
import 'package:escrow_app/services/firestore_service.dart';
import 'package:escrow_app/models/message_model.dart';
import 'package:escrow_app/models/contract_model.dart';
import 'package:escrow_app/widgets/message_bubble.dart';
import 'package:escrow_app/widgets/message_input.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatScreen extends StatelessWidget {
  final String contractId;

  const ChatScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final currentUser = Provider.of<AuthService>(context).currentUser;

    return FutureBuilder<Contract>(
      future: firestoreService.getContract(contractId),
      builder: (context, contractSnapshot) {
        if (contractSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (contractSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Error loading contract: ${contractSnapshot.error}'),
            ),
          );
        }

        final contract = contractSnapshot.data!;

        if (contract.status != 'accepted') {
          return Scaffold(
            appBar: AppBar(title: const Text('Chat Unavailable')),
            body: const Center(
              child: Text('Chat will be available once contract is accepted.'),
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: firestoreService.getMessages(contractId),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (messageSnapshot.hasError) {
                      return Center(
                        child: Text(
                            'Error loading messages: ${messageSnapshot.error}'),
                      );
                    }

                    final messages = messageSnapshot.data ?? [];
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isCurrentUser =
                            message.senderId == currentUser?.id;

                        return Slidable(
                          key: ValueKey(message.id),
                          direction: Axis.horizontal,
                          enabled: isCurrentUser,
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _handleEditMessage(
                                    context, message, contractId),
                                backgroundColor: Colors.blue,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _handleDeleteMessage(
                                    context, message, contractId),
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: MessageBubble(
                            message: message,
                            isMe: isCurrentUser,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (currentUser != null)
                MessageInput(contractId: contractId)
              else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('You must be logged in to send messages'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleEditMessage(
      BuildContext context, Message message, String contractId) {
    final textController = TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<FirestoreService>(context, listen: false)
                    .editMessage(
                  contractId: contractId,
                  messageId: message.id,
                  newText: textController.text.trim(),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error editing message: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteMessage(
      BuildContext context, Message message, String contractId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<FirestoreService>(context, listen: false)
                    .deleteMessage(
                  contractId: contractId,
                  messageId: message.id,
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting message: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
