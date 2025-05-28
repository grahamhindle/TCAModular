import ProjectDescription

let project = Project(
    name: "Main",
    organizationName: "com.grahamhindle",
    packages: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "1.19.1")),
        .remote(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", requirement: .upToNextMajor(from: "1.5.2")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "11.13.0")),
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.9",
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "TARGETED_DEVICE_FAMILY": "1,2",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "ENABLE_TESTABILITY": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
        ]
    ),
    targets: [
        Target.target(
            name: "Main",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grahamhindle.Main",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "AccentColor",
                        "UIImageName": "Image",
                    ],
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true,
                    ],
                ]
            ),
            sources: ["Main/Sources/**"],
            resources: ["Main/Resources/**"],
            dependencies: [
                .target(name: "Root"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "Home",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.Home",
            infoPlist: .default,
            sources: ["Home/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "Settings",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.Settings",
            infoPlist: .default,
            sources: ["Settings/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
            ],
            
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "Tabs",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.Tabs",
            infoPlist: .default,
            sources: ["Tabs/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                .target(name: "Settings"),
                .target(name: "CounterFeature"),
                .target(name: "Contacts"),
                .target(name: "SyncUps"),

               
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "Root",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.Root",
            infoPlist: .default,
            sources: ["Root/Sources/**"],
            dependencies: [
                .target(name: "Tabs"),

                .package(product: "ComposableArchitecture"),
            ],
            settings: .settings(
                base: [
                     "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "RootTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.RootTests",
            infoPlist: .default,
            sources: ["Root/Tests/**"],
            dependencies: [
                .target(name: "Root"),
                .package(product: "XCTestDynamicOverlay"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "MainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.MainTests",
            infoPlist: .default,
            sources: ["Main/Tests/**"],
            dependencies: [
                .target(name: "Main"),
                .package(product: "XCTestDynamicOverlay"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "TabsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.TabsTests",
            infoPlist: .default,
            sources: ["Tabs/Tests/**"],
            dependencies: [
                .target(name: "Tabs"),
                .package(product: "XCTestDynamicOverlay"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "CounterFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.CounterFeature",
            infoPlist: .extendingDefault(
                with: [
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true,
                    ],
                ]
            ),
            sources: ["CounterFeature/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),

        Target.target(
            name: "CounterFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.CounterFeatureTests",
            infoPlist: .default,
            sources: ["CounterFeature/Tests/**"],
            dependencies: [
                .target(name: "CounterFeature"),
                .package(product: "XCTestDynamicOverlay"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                ]
            )
        ),
        Target.target(
            name: "Contacts",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.Contacts",
            infoPlist: .default,
            sources: ["Contacts/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
                ]
            )
        ),

        Target.target(
            name: "ContactsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.ContactsTests",
            infoPlist: .default,
            sources: ["Contacts/Tests/**"],
            dependencies: [
                .target(name: "Contacts"),
                .package(product: "XCTestDynamicOverlay")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
                ]
            )
        ),
        
        Target.target(
            name: "SyncUps",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.grahamhindle.SyncUps",
            infoPlist: .default,
            sources: ["SyncUps/Sources/**"],
            resources: ["SyncUps/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
                ]
            )
        ),

        Target.target(
            name: "SyncUpsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grahamhindle.SyncUpsTests",
            infoPlist: .default,
            sources: ["SyncUps/Tests/**"],
            resources: ["SyncUps/Resources/**"],
            dependencies: [
                .target(name: "SyncUps"),
                .package(product: "XCTestDynamicOverlay")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                    "SWIFT_COMPILATION_MODE": "singlefile",
                    "ENABLE_TESTABILITY": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
                ]
            )
        ),
    ]
)
