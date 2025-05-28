import ComposableArchitecture
import SwiftUI

@Reducer
public struct SyncUpsList {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public init() {}
        @Presents var addSyncUp: SyncUpForm.State?
        @Shared(.syncUps) var syncUps
    }

    public enum Action {
        case addSyncUpButtonTapped
        case addSyncUp(PresentationAction<SyncUpForm.Action>)
        case confirmAddButtonTapped
        case discardButtonTapped
        case onDelete(IndexSet)
        case syncUpTapped(id: SyncUp.ID)
    }

    @Dependency(\.uuid) var uuid
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addSyncUpButtonTapped:
                state.addSyncUp = SyncUpForm.State(
                    syncUp: SyncUp(id: uuid())
                )
                return .none

            case .addSyncUp:
                return .none

            case .confirmAddButtonTapped:
                guard let newSyncUp = state.addSyncUp?.syncUp else {
                    return .none
                }
                state.$syncUps.withLock { _ = $0.append(newSyncUp) }
                state.addSyncUp = nil
                return .none

            case .discardButtonTapped:
                state.addSyncUp = nil
                return .none

            case let .onDelete(indexSet):
                state.$syncUps.withLock { _ = $0.remove(atOffsets: indexSet) }
                return .none

            case let .syncUpTapped(id):
                return .none
            }
        }
        .ifLet(\.$addSyncUp, action: \.addSyncUp) {
            SyncUpForm()
        }
    }
}

extension SharedKey where Self == FileStorageKey<IdentifiedArrayOf<SyncUp>>.Default {
    static var syncUps: Self {
        Self[.fileStorage(.documentsDirectory.appending(component: "sync-ups.json")), default: []]
    }
}

public struct SyncUpsListView: View {
    @Bindable var store: StoreOf<SyncUpsList>
    public init(store: StoreOf<SyncUpsList>) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach(store.syncUps) { syncUp in
                Button {} label: {
                    CardView(syncUp: syncUp)
                }
                .listRowBackground(syncUp.theme.mainColor)
            }
            .onDelete { indexSet in
                store.send(.onDelete(indexSet))
            }
        }
        .sheet(item: $store.scope(state: \.addSyncUp, action: \.addSyncUp)) { addSyncUpStore in
            NavigationStack {
                SyncUpFormView(store: addSyncUpStore)
                    .navigationTitle("New sync-up")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                store.send(.discardButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.send(.confirmAddButtonTapped)
                            }
                        }
                    }
            }
        }
        .toolbar {
            Button {
                store.send(.addSyncUpButtonTapped)
            } label: {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("Daily Sync-ups")
    }
}

public struct CardView: View {
    public let syncUp: SyncUp

    public var body: some View {
        VStack(alignment: .leading) {
            Text(syncUp.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(syncUp.attendees.count)", systemImage: "person.3")
                Spacer()
                Label(syncUp.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundStyle(syncUp.theme.accentColor)
    }
}

public struct TrailingIconLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

public extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}

#Preview {
    @Shared(.syncUps) var syncUps = [.mock]
    NavigationStack {
        SyncUpsListView(
            store: Store(
                initialState: SyncUpsList.State()
            ) {
                SyncUpsList()
                    ._printChanges()
            }
            //.withTestShared(\SyncUpsList.State.syncUps, value: IdentifiedArrayOf<SyncUp>([SyncUp.mock]))
        )
    }
}

//
