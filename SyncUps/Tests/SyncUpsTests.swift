//
//  SyncUpsTests.swift
//  SyncUpsTests
//
//  Created by Graham Hindle on 2025-05-28.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
@testable import SyncUps
import Testing
import XCTestDynamicOverlay

@MainActor
struct SyncUpsListTests {
    @Test
    func addSyncUpNonExhaustive() async {
        let store = TestStore(initialState: SyncUpsList.State()) {
            SyncUpsList()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off(showSkippedAssertions: true)
        await store.send(.addSyncUpButtonTapped)

        let editedSyncUp = SyncUp(
            id: SyncUp.ID(0),
            attendees: [
                Attendee(id: Attendee.ID(), name: "Blob"),
                Attendee(id: Attendee.ID(), name: "Blob Jr."),
            ],
            title: "Point-Free morning sync"
        )
        await store.send(\.addSyncUp.binding.syncUp, editedSyncUp)
        await store.send(.confirmAddButtonTapped) {
            $0.$syncUps.withLock { $0 = [editedSyncUp] }
        }
    }

    @Test
    func addSyncUp() async {
        let store = TestStore(initialState: SyncUpsList.State()) {
            SyncUpsList()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        await store.send(.addSyncUpButtonTapped) {
            $0.addSyncUp = SyncUpForm.State(
                syncUp: SyncUp(id: SyncUp.ID(0))
            )
        }
        let editedSyncUp = SyncUp(
            id: SyncUp.ID(0),
            attendees: [
                Attendee(id: Attendee.ID(), name: "Blob"),
                Attendee(id: Attendee.ID(), name: "Blob Jr."),
            ],
            title: "Point-Free morning sync"
        )
        await store.send(\.addSyncUp.binding.syncUp, editedSyncUp) {
            $0.addSyncUp?.syncUp = editedSyncUp
        }
        await store.send(.confirmAddButtonTapped) {
            $0.addSyncUp = nil
            $0.$syncUps.withLock { $0 = [editedSyncUp] }
        }
    }

    @Test
    func deletion() async {
        @Shared(.syncUps) var syncUps = [
            SyncUp(id: SyncUp.ID(),
                   title: "Point-Free morning sync"),
        ]
        let store = TestStore(
            initialState: SyncUpsList.State()
        ) {
            SyncUpsList()
        }
        await store.send(.onDelete([0])) {
            $0.$syncUps.withLock { $0 = [] }
        }
    }
}
