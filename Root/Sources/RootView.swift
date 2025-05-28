import ComposableArchitecture


import SwiftUI
import Tabs

@Reducer(state: .equatable)
public enum RootMode {
    case launching
    case tabs(TabsFeature)
  
   // case contacts(ContactsFeature.State)
}

@Reducer
public struct RootFeature {
    public init() {}

    @ObservableState
    public struct State {
        public init() {}
        public var mode: RootMode.State? = .launching
    }

    public enum Action {
        case didFinishLaunching
        case mode(RootMode.Action)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                print("RootFeature didFinishLaunching")
                state.mode = .tabs(TabsFeature.State())
                // state.mode = .counter(CounterFeature.State())
                return .none
            case .mode:
                return .none
            }
        }
        .ifLet(\.mode, action: \.mode) {
            RootMode.body
        }
    }
}

public struct RootView: View {
    let store: StoreOf<RootFeature>
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        if let store = store.scope(state: \.mode, action: \.mode) {
            switch store.case {
            case .launching:
                Text("Launching")

            case let .tabs(tabsStore):
                TabsView(store: tabsStore)

            }
        }
    }
}

#Preview {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    RootView(store: appDelegate.store)
        .onAppear {
            appDelegate.store.send(.didFinishLaunching)
        }
}
