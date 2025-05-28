#!/bin/bash

# Check if module name is provided
if [ -z "$1" ]; then
    echo "Error: Module name is required"
    echo "Usage: ./generate_module.sh <ModuleName>"
    exit 1
fi

MODULE_NAME=$1
MODULE_PATH="$MODULE_NAME"

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
import XCTestDynamicOverlay
@testable import ${MODULE_NAME}

final class ${MODULE_NAME}Tests: XCTestCase {
    func testExample() throws {
        let store = TestStore(initialState: ${MODULE_NAME}Feature.State()) {
            ${MODULE_NAME}Feature()
        }
    }
}
EOL

# Create a temporary file for the new Project.swift
TEMP_PROJECT="temp_project.swift"

# Read the existing Project.swift and add the new module
awk -v module="$MODULE_NAME" '
BEGIN { in_targets = 0; added = 0; }
/^    targets: \[/ { in_targets = 1; print; next; }
in_targets && !added && /^    \]/ {
    print "        Target.target(";
    print "            name: \"" module "\",";
    print "            destinations: .iOS,";
    print "            product: .staticFramework,";
    print "            bundleId: \"com.grahamhindle." module "\",";
    print "            infoPlist: .default,";
    print "            sources: [\"" module "/Sources/**\"],";
    print "            dependencies: [";
    print "                .package(product: \"ComposableArchitecture\")";
    print "            ],";
    print "            settings: .settings(";
    print "                base: [";
    print "                    \"SWIFT_VERSION\": \"5.9\",";
    print "                    \"IPHONEOS_DEPLOYMENT_TARGET\": \"16.0\",";
    print "                    \"SWIFT_ACTIVE_COMPILATION_CONDITIONS\": \"DEBUG\",";
    print "                    \"GCC_PREPROCESSOR_DEFINITIONS\": \"DEBUG=1\",";
    print "                    \"SWIFT_OPTIMIZATION_LEVEL\": \"-Onone\",";
    print "                    \"SWIFT_COMPILATION_MODE\": \"singlefile\",";
    print "                    \"ENABLE_TESTABILITY\": \"YES\",";
    print "                    \"ENABLE_USER_SCRIPT_SANDBOXING\": \"NO\"";
    print "                ]";
    print "            )";
    print "        ),";
    print "";
    print "        Target.target(";n
    print "            name: \"" module "Tests\",";
    print "            destinations: .iOS,";
    print "            product: .unitTests,";
    print "            bundleId: \"com.grahamhindle." module "Tests\",";
    print "            infoPlist: .default,";
    print "            sources: [\"" module "/Tests/**\"],";
    print "            dependencies: [";
    print "                .target(name: \"" module "\"),";
    print "                .package(product: \"XCTestDynamicOverlay\")";
    print "            ],";
    print "            settings: .settings(";
    print "                base: [";
    print "                    \"SWIFT_VERSION\": \"5.9\",";
    print "                    \"IPHONEOS_DEPLOYMENT_TARGET\": \"18.0\",";
    print "                    \"SWIFT_ACTIVE_COMPILATION_CONDITIONS\": \"DEBUG\",";
    print "                    \"GCC_PREPROCESSOR_DEFINITIONS\": \"DEBUG=1\",";
    print "                    \"SWIFT_OPTIMIZATION_LEVEL\": \"-Onone\",";
    print "                    \"SWIFT_COMPILATION_MODE\": \"singlefile\",";
    print "                    \"ENABLE_TESTABILITY\": \"YES\",";
    print "                    \"ENABLE_USER_SCRIPT_SANDBOXING\": \"NO\"";
    print "                ]";
    print "            )";
    print "        ),";
    added = 1;
}
{ print; }
' Project.swift > "$TEMP_PROJECT"

# Replace the original Project.swift with the updated version
mv "$TEMP_PROJECT" Project.swift

echo "Module ${MODULE_NAME} has been generated successfully!"
echo "Path: ${MODULE_PATH}"
echo "Project.swift has been updated with the new module."
echo "Please run 'tuist generate' to update your Xcode project." 