//
//  ContactsView.swift
//  Contacts
//
//  Created by Graham Hindle on 2025-05-25.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct Contact: Equatable, Identifiable {
    public let id: UUID
    public var name: String
}

@Reducer
public struct ContactsFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public init() {}
//    @Presents var addContact: AddContactFeature.State?
//      @Presents var alert: AlertState<Action.Alert>?
        @Presents var destination: Destination.State?
        public var contacts: IdentifiedArrayOf<Contact> = []
        var path = StackState<ContactDetailFeature.State>()
    }

    public enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        case path(StackActionOf<ContactDetailFeature>)
        public enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }

    @Dependency(\.uuid) var uuid
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: self.uuid(), name: "")
                    )
                )
                return .none

            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none

            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none

            case .destination:
                return .none

            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none

            case let .path(.element(id: id, action: .delegate(.confirmDeletion))):
                guard let detailState = state.path[id: id]
                else { return .none }
                state.contacts.remove(id: detailState.contact.id)
                return .none

            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
        .forEach(\.path, action: \.path) {
            ContactDetailFeature()
        }
    }
}

public extension ContactsFeature {
    @Reducer
    public enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}

extension ContactsFeature.Destination.State: Equatable {}

public struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    public init(store: StoreOf<ContactsFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                ForEach(store.contacts) { contact in
                    NavigationLink(state: ContactDetailFeature.State(contact: contact)) {
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        destination: { store in
            ContactDetailView(store: store)
        }
        .sheet(
            item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

// #Preview {
//    @State var C
//    ContactsView(
//        store: Store(
//            initialState: ContactsFeature.State(
//                contacts: [
//                    Contact(id: UUID(), name: "Blob"),
//                    Contact(id: UUID(), name: "Blob Jr"),
//                    Contact(id: UUID(), name: "Blob Sr"),
//                ]
//            )
//        ) {
//            ContactsFeature()
//        }
//    )
// }
