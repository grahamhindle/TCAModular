//
//  SettingsView.swift
//  Settings
//
//  Created by Graham Hindle on 2025-05-24.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture

import SwiftUI

@Reducer
public struct SettingsFeature {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {}
        }
    }
}

public struct SettingsView: View {
    let store: StoreOf<SettingsFeature>

    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Settings")
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
    })
}
