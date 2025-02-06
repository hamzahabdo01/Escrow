import 'package:escrow_app/screens/chat_screen.dart';
import 'package:escrow_app/screens/create_contract_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contract_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class PendingContractsScreen extends StatelessWidget {
  const PendingContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final currentUser = Provider.of<AuthService>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Contracts',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF059EDB),
        elevation: 0,
      ),
      body: StreamBuilder<List<Contract>>(
        stream: firestoreService.getReceivedContracts(currentUser!.id),
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
                'Error loading contracts: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final contracts = snapshot.data ?? [];
          final pendingContracts =
              contracts.where((c) => c.status == 'pending').toList();

          if (pendingContracts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No pending contracts found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateContractScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF059EDB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Create New Contract',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: pendingContracts.length,
            itemBuilder: (context, index) {
              final contract = pendingContracts[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    contract.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059EDB)),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'From: ${contract.senderId}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${contract.status}',
                        style: TextStyle(
                            fontSize: 14,
                            color: contract.status == 'pending'
                                ? Colors.orange
                                : Colors.green),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green, size: 24),
                        onPressed: () async {
                          try {
                            await firestoreService.updateContractStatus(
                              contract.id,
                              'accepted',
                              currentUser.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contract accepted!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error accepting contract: $e',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 24),
                        onPressed: () async {
                          try {
                            await firestoreService.updateContractStatus(
                              contract.id,
                              'rejected',
                              currentUser.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contract rejected!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error rejecting contract: $e',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    if (contract.status == 'accepted') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(contractId: contract.id),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
