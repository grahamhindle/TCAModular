import ComposableArchitecture
import SwiftUI


@Reducer
public struct AddContactFeature {
  @ObservableState
  public struct State: Equatable {
    public var contact: Contact
  }
  public enum Action {
    case cancelButtonTapped
    case delegate(Delegate)
    case saveButtonTapped
    case setName(String)
    @CasePathable
    public enum Delegate: Equatable {
           // case cancel
            case saveContact(Contact)
          }
  }
    @Dependency(\.dismiss) var dismiss
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelButtonTapped:
              return .run { _ in await self.dismiss() }

      case .delegate:
        return .none

      case .saveButtonTapped:
        return .run { [contact = state.contact] send in
        await send(.delegate(.saveContact(contact)))
        await self.dismiss()
      }

      case let .setName(name):
        state.contact.name = name
        return .none
      }
    }
  }
}

public struct AddContactView: View {
  @Bindable var store: StoreOf<AddContactFeature>
    public init (store: StoreOf<AddContactFeature>){
        self.store = store
    }

  public var body: some View {
    Form {
      TextField("Name", text: $store.contact.name.sending(\.setName))
      Button("Save") {
        store.send(.saveButtonTapped)
      }
    }
    .toolbar {
      ToolbarItem {
        Button("Cancel") {
          store.send(.cancelButtonTapped)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    AddContactView(
      store: Store(
        initialState: AddContactFeature.State(
          contact: Contact(
            id: UUID(),
            name: "Blob"
          )
        )
      ) {
        AddContactFeature()
      }
    )
  }
}


