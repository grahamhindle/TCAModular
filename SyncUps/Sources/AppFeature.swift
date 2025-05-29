import ComposableArchitecture
import SwiftUI
@Reducer
public struct AppFeature {
    @Reducer 
    public enum Path {
        case detail(SyncUpDetail)
    }
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
        var syncUpsList = SyncUpsList.State()
    }
    public enum Action {
        case path(StackActionOf<Path>)
        case syncUpsList(SyncUpsList.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.syncUpsList, action: \.syncUpsList) {
            SyncUpsList()
        }
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .syncUpsList:
                return .none
            }
        }
        .forEach(\.path, action: \.path) 
    }
}

extension AppFeature.Path.State: Equatable {}

public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            SyncUpsListView(store: store.scope(state: \.syncUpsList, action: \.syncUpsList))
        } destination: { store in
            switch store.case {
            case let .detail(detailStore):
                SyncUpDetailView(store: detailStore)
            }
        }
    }
}

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(
        syncUpsList: SyncUpsList.State()
      )
    ) {
      AppFeature()
    }
  )
}