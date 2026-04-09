import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_viewmodel.g.dart';

// State
class ContactState {
  final List<Contact> contacts;
  final bool isLoading;
  final bool hasPermission;
  final String? errorMessage;
  final Contact? selectedContact;

  const ContactState({
    this.contacts = const [],
    this.isLoading = false,
    this.hasPermission = false,
    this.errorMessage,
    this.selectedContact,
  });

  ContactState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    bool? hasPermission,
    String? errorMessage,
    Contact? selectedContact,
  }) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      errorMessage: errorMessage,
      selectedContact: selectedContact ?? this.selectedContact,
    );
  }
}

// ViewModel
@riverpod
class ContactViewModel extends _$ContactViewModel {
  @override
  ContactState build() => const ContactState();

  // Request permission and load contacts
  Future<void> loadContacts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final hasPermission = await FlutterContacts.requestPermission(readonly: true);

      if (!hasPermission) {
        state = state.copyWith(
          isLoading: false,
          hasPermission: false,
          errorMessage: 'Permission denied',
        );
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      state = state.copyWith(
        contacts: contacts,
        isLoading: false,
        hasPermission: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
  void selectContact(Contact contact) {
    state = state.copyWith(selectedContact: contact);
  }
  // Pick contact and fill debt form
  Future<Contact?> pickContact() async {
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        state = state.copyWith(selectedContact: contact);
      }
      return contact;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }
}