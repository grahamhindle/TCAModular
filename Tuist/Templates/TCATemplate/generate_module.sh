#!/bin/bash

# Check if module name is provided
if [ -z "$1" ]; then
    echo "Error: Module name is required"
    echo "Usage: ./generate_module.sh <ModuleName>"
    exit 1
fi

MODULE_NAME=$1
MODULE_PATH="Modules/$MODULE_NAME"

# Create module directory structure
mkdir -p "$MODULE_PATH/Sources"
mkdir -p "$MODULE_PATH/Tests"

# Generate View file
cat > "$MODULE_PATH/Sources/${MODULE_NAME}View.swift" << EOL
//
//  ${MODULE_NAME}View.swift
//  ${MODULE_NAME}
//
//  Created by $(git config user.name) on $(date +%Y-%m-%d).
//  Copyright © $(date +%Y) $(git config user.name). All rights reserved.
//

import ComposableArchitecture
import Perception
import SwiftUI

@Reducer
public struct ${MODULE_NAME}Feature {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {}
        }
    }
}

public struct ${MODULE_NAME}View: View {
    @Perception.Bindable var store: StoreOf<${MODULE_NAME}Feature>
    
    public init(store: StoreOf<${MODULE_NAME}Feature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            // Your view content here
        }
    }
}

#Preview {
    WithPerceptionTracking {
        ${MODULE_NAME}View(store: Store(initialState: ${MODULE_NAME}Feature.State()) {
            ${MODULE_NAME}Feature()
        })
    }
}
EOL

# Generate Test file
cat > "$MODULE_PATH/Tests/${MODULE_NAME}Tests.swift" << EOL
//
//  ${MODULE_NAME}Tests.swift
//  ${MODULE_NAME}Tests
//
//  Created by $(git config user.name) on $(date +%Y-%m-%d).
//  Copyright © $(date +%Y) $(git config user.name). All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import ${MODULE_NAME}

final class ${MODULE_NAME}Tests: XCTestCase {
    func testExample() throws {
        let store = TestStore(initialState: ${MODULE_NAME}Feature.State()) {
            ${MODULE_NAME}Feature()
        }
    }
}
EOL

# Make the script executable
chmod +x "$MODULE_PATH/generate_module.sh"

echo "Module ${MODULE_NAME} has been generated successfully!"
echo "Path: ${MODULE_PATH}" 