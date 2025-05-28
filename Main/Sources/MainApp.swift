import SwiftUI
import ComposableArchitecture
import Root

@main
struct Main: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView(store: self.appDelegate.store)
            
        }
    }
}
