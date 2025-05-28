//
//  TabsView.swift
//  Tabs
//
//  Created by Graham Hindle on May 2024.
//  Copyright © 2024 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import Perception
import SwiftUI

import CounterFeature
import SyncUps

import Contacts
import Settings

public enum Tab: Equatable, Sendable {
    // case contacts
    case settings
    case counter
    case contacts
    case syncUps
}

@Reducer
public struct TabsFeature {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public init(selectedTab: Tab = .counter) {
            self.selectedTab = selectedTab
            settingsTab = SettingsFeature.State()
            counterTab = CounterFeature.State()
            contactsTab = ContactsFeature.State()
            syncUpsTab = SyncUpsList.State()
        }

        var selectedTab: Tab

        var settingsTab: SettingsFeature.State
        var counterTab: CounterFeature.State
        var contactsTab: ContactsFeature.State
        var syncUpsTab: SyncUpsList.State
    }

    public enum Action {
        case tabSelected(Tab)
        // case contactsTab(ContactsFeature.Action)
        case settingsTab(SettingsFeature.Action)
        case counterTab(CounterFeature.Action)
        case contactsTab(ContactsFeature.Action)
        case syncUpsTab(SyncUpsList.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.contactsTab, action: \.contactsTab) {
            ContactsFeature()
        }
        Scope(state: \.settingsTab, action: \.settingsTab) {
            SettingsFeature()
        }
        Scope(state: \.counterTab, action: \.counterTab) {
            CounterFeature()
        }
        Scope(state: \.syncUpsTab, action: \.syncUpsTab) {
            SyncUpsList()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            case .contactsTab:
                return .none
            case .settingsTab:

                return .none
            case .counterTab:

                return .none
            case .syncUpsTab:
                return .none
            }
        }
    }
}

public struct TabsView: View {
    @Bindable var store: StoreOf<TabsFeature>
    public init(store: StoreOf<TabsFeature>) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            ContactsView(store: store.scope(
               state: \.contactsTab,
               action: \.contactsTab))
            .tabItem {
                Image(systemName: "person.3")
                Text("Contacts")
            }
            .tag(Tab.contacts)

            SettingsView(store: store.scope(
                state: \.settingsTab,
                action: \.settingsTab
            ))
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(Tab.settings)

            CounterView(store: store.scope(
                state: \.counterTab,
                action: \.counterTab
            ))
            .tabItem {
                Image(systemName: "plus")
                Text("Counter")
            }
            .tag(Tab.counter)

            NavigationStack {
                SyncUpsListView(store: store.scope(
                    state: \.syncUpsTab,
                    action: \.syncUpsTab
                ))
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Sync Ups")
            }
            .tag(Tab.syncUps)
        }
    }
}

#Preview {
    TabsView(store: Store(initialState: TabsFeature.State()) {
        TabsFeature()
    })
}
