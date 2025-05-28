import ComposableArchitecture
import SwiftUI

@Reducer
public struct SyncUpDetail {
    @ObservableState
    public struct State: Equatable {
        @Shared public var syncUp: SyncUp
    }

    public enum Action {
        case deleteButtonTapped
        case editButtonTapped
    }

    @Dependency(\.uuid) var uuid

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .deleteButtonTapped:
                return .none
            case .editButtonTapped:
                return .none
            }
        }
    }
}

public struct SyncUpDetailView: View {
    let store: StoreOf<SyncUpDetail>

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
        .navigationTitle(Text(store.syncUp.title))
        .toolbar {
            Button("Edit") {
                store.send(.editButtonTapped)
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