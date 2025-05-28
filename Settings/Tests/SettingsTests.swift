//
//  SettingsTests.swift
//  SettingsTests
//
//  Created by Graham Hindle on 2025-05-24.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import XCTest
import XCTestDynamicOverlay
@testable import Settings

final class SettingsTests: XCTestCase {
    func testExample() throws {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    }
}
