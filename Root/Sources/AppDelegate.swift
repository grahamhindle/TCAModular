import ComposableArchitecture
import Foundation
import SwiftUI


public class AppDelegate: NSObject, UIApplicationDelegate {
    public let store = Store(initialState: RootFeature.State()) {
        RootFeature()
        ._printChanges()
    }

    public func application(_: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("AppDelegate didFinishLaunchingWithOptions")

        store.send(.didFinishLaunching)
        return true
    }
   
}
