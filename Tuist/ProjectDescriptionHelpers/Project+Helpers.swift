import ProjectDescription

// MARK: - Common Settings

extension Settings {
    static let commonSettings: Settings = .settings(
        base: [
            "SWIFT_VERSION": "5.9",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "TARGETED_DEVICE_FAMILY": "1,2",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "ENABLE_TESTABILITY": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
        ]
    )
}

// MARK: - Common Dependencies

extension TargetDependency {
    static let tcaDependencies: [TargetDependency] = [
        .package(product: "ComposableArchitecture"),
        .package(product: "XCTestDynamicOverlay"),
    ]
}

// MARK: - Target Helpers

extension Target {
    static func framework(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: bundleId,
            infoPlist: .default,
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        )
    }

    static func tests(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target.target(
            name: name,
            destinations: .iOS,
            product: .unitTests,
            bundleId: bundleId,
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        )
    }
}
