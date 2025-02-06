import 'package:escrow_app/models/contract_model.dart';
import 'package:escrow_app/screens/contract_detail_screen.dart';
import 'package:escrow_app/screens/create_contract_screen.dart';
import 'package:escrow_app/screens/login_screen.dart';
import 'package:escrow_app/screens/pending_contract_screen.dart';
import 'package:escrow_app/services/auth_service.dart';
import 'package:escrow_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  void _handleDeleteContract(BuildContext context, Contract contract) async {
    bool shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Deletion',
                style: TextStyle(color: Color(0xFF059EDB))),
            content: const Text(
                'Are you sure you want to delete this contract?',
                style: TextStyle(color: Colors.black87)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      try {
        final firestoreService =
            Provider.of<FirestoreService>(context, listen: false);
        await firestoreService.deleteContract(contract.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Contract deleted successfully',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Color(0xFF059EDB)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error deleting contract: $e',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _handleEditContract(BuildContext context, Contract contract) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateContractScreen(contract: contract),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF059EDB),
        elevation: 0,
        title: const Text(
          'My Contracts',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateContractScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 30),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Contract>>(
        stream: firestoreService.getSentContracts(currentUser!.id),
        builder: (context, sentSnapshot) {
          return StreamBuilder<List<Contract>>(
            stream: firestoreService.getReceivedContracts(currentUser.id),
            builder: (context, receivedSnapshot) {
              if (sentSnapshot.connectionState == ConnectionState.waiting ||
                  receivedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF059EDB),
                  ),
                );
              }

              final sentContracts = sentSnapshot.data ?? [];
              final receivedContracts = receivedSnapshot.data ?? [];
              final allContracts = [...sentContracts, ...receivedContracts];

              if (allContracts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No contracts found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateContractScreen(),
                          ),
                        ),
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
                itemCount: allContracts.length,
                itemBuilder: (context, index) {
                  final contract = allContracts[index];
                  final isSender = contract.senderId == currentUser.id;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: ValueKey(contract.id),
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          if (isSender)
                            SlidableAction(
                              onPressed: (_) =>
                                  _handleEditContract(context, contract),
                              backgroundColor: const Color(0xFFF2D04C),
                              icon: Icons.edit,
                              label: 'Edit',
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          if (isSender)
                            SlidableAction(
                              onPressed: (_) =>
                                  _handleDeleteContract(context, contract),
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                        ],
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
                            Text(
                              'Status: ${contract.status}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'With: ${isSender ? contract.receiverId : contract.senderId}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${DateFormat.yMd().format(contract.startDate)} - ${DateFormat.yMd().format(contract.endDate)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${contract.paymentAmount} - ${contract.paymentTerms}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                        trailing: contract.status == 'sent' && isSender
                            ? const Icon(Icons.pending_actions,
                                color: Color(0xFFF2D04C), size: 24)
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ContractDetailScreen(contract: contract),
                            ),
                          );
                        },
                        tileColor: Colors.white,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PendingContractsScreen()),
        ),
        tooltip: 'View Pending Contracts',
        backgroundColor: const Color(0xFFF2D04C),
        child: const Icon(Icons.assignment, color: Colors.black87, size: 30),
      ),
    );
  }
}
