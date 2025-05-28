//
//  HomeTests.swift
//  HomeTests
//
//  Created by Graham Hindle on 2025-05-24.
//  Copyright © 2025 Graham Hindle. All rights reserved.
//

import ComposableArchitecture
import XCTest
import XCTestDynamicOverlay
@testable import Home

final class HomeTests: XCTestCase {
    func testExample() throws {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    }
}
