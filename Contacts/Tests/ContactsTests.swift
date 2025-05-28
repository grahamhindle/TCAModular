//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Graham Hindle on 2025-05-25.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import Foundation
@testable import Contacts
import Testing

@MainActor
struct ContactsTests {
    @Test func addFlow() async throws {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                contact: Contact(
                    id: UUID(0),
                    name: ""
                )
            ))
        }
        await store.send(\.destination.addContact.setName, "Graham") {
            $0.destination?.modify(\.addContact) { $0.contact.name = "Graham" }
        }
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.receive(
            \.destination.addContact.delegate.saveContact,
            Contact(id: UUID(0), name: "Graham")
        ) {
            $0.contacts = [Contact(id: UUID(0), name: "Graham")]
        }
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
}
