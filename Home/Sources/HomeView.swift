//
//  HomeView.swift
//  Home
//
//  Created by Graham Hindle on 2025-05-24.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture

import SwiftUI

@Reducer
public struct HomeFeature {
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

public struct HomeView: View {
    let store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Home")
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State()) {
        HomeFeature()
    })
}
