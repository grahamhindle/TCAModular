import ComposableArchitecture
import SwiftUI

@Reducer
public struct SyncUpDetail {
    @Reducer
    public enum Destination {
        case alert(AlertState<Alert>)
        case edit(SyncUpForm)
        @CasePathable
        public enum Alert {
            case confirmButtonTapped
        }
    }

    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
        @Shared public var syncUp: SyncUp
    }

    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case cancelEditButtonTapped
        case deleteButtonTapped
        case doneEditingButtonTapped
        case editButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.alert(.confirmButtonTapped))):
                @Shared(.syncUps) var syncUps: IdentifiedArrayOf<SyncUp>
                $syncUps.withLock { _ = $0.remove(id: state.syncUp.id) }
                return .run { _ in await dismiss() }

            

            case .cancelEditButtonTapped:
                state.destination = nil
                return .none

            
            case .destination:
                return .none

            case .deleteButtonTapped:
                state.destination = .alert(.deleteSyncUp)
                return .none

            case .doneEditingButtonTapped:
                guard let editedSyncUp = state.destination?.edit?.syncUp else { return .none }
                state.$syncUp.withLock {
                    $0 = editedSyncUp
                }
                state.destination = nil
                return .none

            case .editButtonTapped:
                state.destination = .edit(SyncUpForm.State(syncUp: state.syncUp))
                return .none

           
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension AlertState where Action == SyncUpDetail.Destination.Alert {
    static let deleteSyncUp = Self {
        TextState("Delete?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmButtonTapped) {
            TextState("Yes")
        }
        ButtonState(role: .cancel) {
            TextState("Nevermind")
        }
    } message: {
        TextState("Are you sure you want to delete this meeting?")
    }
}

extension SyncUpDetail.Destination.State: Equatable {}

public struct SyncUpDetailView: View {
    @Bindable var store: StoreOf<SyncUpDetail>

    public var body: some View {
        Form {
            Section {
                NavigationLink {} label: {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text(store.syncUp.duration.formatted(.units()))
                }

                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(store.syncUp.theme.name)
                        .padding(4)
                        .foregroundColor(store.syncUp.theme.accentColor)
                        .background(store.syncUp.theme.mainColor)
                        .cornerRadius(4)
                }
            } header: {
                Text("Sync-up Info")
            }

            if !store.syncUp.meetings.isEmpty {
                Section {
                    ForEach(store.syncUp.meetings) { meeting in
                        Button {} label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text(meeting.date, style: .date)
                                Text(meeting.date, style: .time)
                            }
                        }
                    }
                } header: {
                    Text("Past meetings")
                }
            }

            Section {
                ForEach(store.syncUp.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } header: {
                Text("Attendees")
            }

            Section {
                Button("Delete") {
                    store.send(.deleteButtonTapped)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        
        .toolbar {
            Button("Edit") {
                store.send(.editButtonTapped)
            }
        }
        .navigationTitle(Text(store.syncUp.title))
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        .sheet(item: $store.scope(state: \.destination?.edit, action: \.destination.edit)) { editSyncupStore in
            NavigationStack {
                SyncUpFormView(store: editSyncupStore)
                    .navigationTitle(Text(store.syncUp.title))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                store.send(.cancelEditButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                store.send(.doneEditingButtonTapped)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SyncUpDetailView(
            store: Store(
                initialState: SyncUpDetail.State(
                    syncUp: Shared(value: .mock)
                )
            ) {
                SyncUpDetail()
            }
        )
    }
}
