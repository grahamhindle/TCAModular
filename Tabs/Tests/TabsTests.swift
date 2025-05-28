//
//  TabsTests.swift
//  Tabs
//
//  Created by Graham Hindle on May 2024.
//  Copyright © 2024 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
@testable import Contacts
import Perception
@testable import Settings
@testable import Tabs
import Testing

@MainActor
struct TabsTests {
    @Test func testTabsSelectede() async throws {
        let store = TestStoreOf<TabsFeature>(initialState: TabsFeature.State()) {
            TabsFeature()
        }
        #expect(store.state.selectedTab == .counter)

        await store.send(.tabSelected(.settings)) {
            $0.selectedTab = .settings
        }
    }
}
