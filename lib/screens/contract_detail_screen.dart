// import 'package:escrow_app/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/contract_model.dart';
// import 'chat_screen.dart';

// class ContractDetailScreen extends StatelessWidget {
//   final Contract contract;

//   const ContractDetailScreen({super.key, required this.contract});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(contract.title),
//           bottom: const TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.description), text: 'Details'),
//               Tab(icon: Icon(Icons.chat), text: 'Chat'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildDetailsTab(context),
//             _buildChatTab(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailsTab(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildDetailItem('Status', contract.status.toUpperCase()),
//           _buildDetailItem('Start Date', _formatDate(contract.startDate)),
//           _buildDetailItem('End Date', _formatDate(contract.endDate)),
//           _buildDetailItem('Payment Amount', '\$${contract.paymentAmount}'),
//           _buildDetailItem('Payment Terms', contract.paymentTerms),
//           const SizedBox(height: 24),
//           Text('Participants:', style: Theme.of(context).textTheme.titleLarge),
//           const SizedBox(height: 16),
//           _buildParticipantSection(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatTab() {
//     if (contract.status != 'accepted') {
//       return const Center(
//         child: Text('Chat will be available once contract is accepted'),
//       );
//     }
//     return ChatScreen(contractId: contract.id);
//   }

//   Widget _buildParticipantSection(BuildContext context) {
//     return FutureBuilder<Map<String, AppUser>>(
//       future: _fetchParticipants(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error loading participants: ${snapshot.error}',
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data == null) {
//           return const Text('No participant data found');
//         }

//         final participants = snapshot.data!;
//         return Column(
//           children: [
//             _buildParticipantCard(participants['sender']!, 'Sender'),
//             const SizedBox(height: 16),
//             _buildParticipantCard(participants['receiver']!, 'Receiver'),
//           ],
//         );
//       },
//     );
//   }

//   Future<Map<String, AppUser>> _fetchParticipants() async {
//     final sender = await _fetchUser(contract.senderId);
//     final receiver = await _fetchUser(contract.receiverId);
//     return {'sender': sender, 'receiver': receiver};
//   }

//   Future<AppUser> _fetchUser(String userId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       if (!doc.exists) {
//         throw Exception('User not found');
//       }
//       return AppUser.fromMap(doc.data()!, doc.id);
//     } catch (e) {
//       throw Exception('Failed to fetch user: $e');
//     }
//   }

//   Widget _buildParticipantCard(AppUser user, String role) {
//     return Card(
//       child: ListTile(
//         leading: const CircleAvatar(child: Icon(Icons.person)),
//         title: Text(user.firstName),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(user.email),
//             Text(role, style: const TextStyle(fontStyle: FontStyle.italic)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return DateFormat('MMM dd, yyyy').format(date);
//   }
// }

import 'package:escrow_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contract_model.dart';
import 'chat_screen.dart';

class ContractDetailScreen extends StatelessWidget {
  final Contract contract;

  const ContractDetailScreen({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            contract.title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF059EDB),
          bottom: const TabBar(
            indicatorColor: Color(0xFFF2D04C),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.description, color: Colors.white),
                text: 'Details',
              ),
              Tab(
                icon: Icon(Icons.chat, color: Colors.white),
                text: 'Chat',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(context),
            _buildChatTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Status', contract.status.toUpperCase()),
          _buildDetailItem('Start Date', _formatDate(contract.startDate)),
          _buildDetailItem('End Date', _formatDate(contract.endDate)),
          _buildDetailItem('Payment Amount', '\$${contract.paymentAmount}'),
          _buildDetailItem('Payment Terms', contract.paymentTerms),
          const SizedBox(height: 24),
          Text(
            'Participants:',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFF059EDB), fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildParticipantSection(context),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    if (contract.status != 'accepted') {
      return Center(
        child: Text(
          'Chat will be available once contract is accepted',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ChatScreen(contractId: contract.id);
  }

  Widget _buildParticipantSection(BuildContext context) {
    return FutureBuilder<Map<String, AppUser>>(
      future: _fetchParticipants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF059EDB),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading participants: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text(
            'No participant data found',
            style: TextStyle(color: Colors.grey),
          );
        }

        final participants = snapshot.data!;
        return Column(
          children: [
            _buildParticipantCard(participants['sender']!, 'Sender'),
            const SizedBox(height: 16),
            _buildParticipantCard(participants['receiver']!, 'Receiver'),
          ],
        );
      },
    );
  }

  Future<Map<String, AppUser>> _fetchParticipants() async {
    final sender = await _fetchUser(contract.senderId);
    final receiver = await _fetchUser(contract.receiverId);
    return {'sender': sender, 'receiver': receiver};
  }

  Future<AppUser> _fetchUser(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return AppUser.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Widget _buildParticipantCard(AppUser user, String role) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF2D04C),
          child: const Icon(Icons.person, color: Colors.black87),
        ),
        title: Text(
          user.firstName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: const TextStyle(color: Colors.black87)),
            Text(
              role,
              style: const TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF059EDB)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
