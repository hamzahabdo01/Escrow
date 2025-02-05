// class AppUser {
//   final String id;
//   final String email;
//   final String name;

//   AppUser({
//     required this.id,
//     required this.email,
//     required this.name,
//   });
//    @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         (other is AppUser &&
//             runtimeType == other.runtimeType &&
//             id == other.id);
//   }
//    @override
//   int get hashCode => id.hashCode;

//   factory AppUser.fromMap(Map<String, dynamic> data, String id) {
//     return AppUser(
//       id: id,
//       email: data['email'] ?? '',
//       name: data['name'] ?? 'Unknown',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'email': email,
//       'name': name,
//     };
//   }
// }
class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String bankAccount;
  final String industry;
  final String profilePicture;

  AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.bankAccount,
    required this.industry,
    required this.profilePicture,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppUser &&
            runtimeType == other.runtimeType &&
            id == other.id);
  }

  @override
  int get hashCode => id.hashCode;

  // Factory method to create an AppUser instance from a Firestore document map
  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? 'Unknown',
      middleName: data['middleName'] ?? '',
      lastName: data['lastName'] ?? 'Unknown',
      bankAccount: data['bankAccount'] ?? '',
      industry: data['industry'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
    );
  }

  // Method to convert an AppUser instance into a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'bankAccount': bankAccount,
      'industry': industry,
      'profilePicture': profilePicture,
    };
  }
}
