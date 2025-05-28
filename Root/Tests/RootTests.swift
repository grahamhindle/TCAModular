import ComposableArchitecture
import Perception
import Root
import Tabs
import Testing

@testable import Root

@MainActor
struct RootTests {
    @Test func didFinishLaunching() async throws {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        
        // Verify initial state
        #expect(store.state.mode == .launching)
        
        // Test the launch action
        await store.send(.didFinishLaunching) {
            $0.mode = .tabs(TabsFeature.State())
        }
    }
    
    @Test func rootView() {
        let store = Store(initialState: RootFeature.State()) {
            RootFeature()
        }
        
        let view = RootView(store: store)
        
        // Test that the view can be created
        #expect(view != nil)
    }
}
