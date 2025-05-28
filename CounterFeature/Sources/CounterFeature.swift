//
//  CounterFeature.swift
//  CounterFeature
//
//  Created by Graham Hindle on 2025-05-25.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct CounterFeature {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var count = 0
        public var fact: String?
        public var isLoading = false
        public var isTimerRunning = false
        public init(count: Int = 0, fact: String? = nil, isLoading: Bool = false, isTimerRunning: Bool = false) {
            self.count = count
            self.fact = fact
            self.isLoading = isLoading
            self.isTimerRunning = isTimerRunning
        }
    }

    public enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }

    enum CancelID: Hashable {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact: NumberFactClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none

            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    let fact = try await self.numberFact.fetch(count)
                    await send(.factResponse(fact))
                }

            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none

            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none

            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none

            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}



public struct CounterView: View {
    @Bindable public var store: StoreOf<CounterFeature>

    public init(store: StoreOf<CounterFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            VStack {
                Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                    store.send(.toggleTimerButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

                Button("Fact") {
                    store.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

                if store.isLoading {
                    ProgressView()
                } else if let fact = store.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(
            initialState: CounterFeature.State())
        {
            CounterFeature()
        }
    )
}
