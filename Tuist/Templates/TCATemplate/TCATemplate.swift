import ProjectDescription
import Foundation

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "A template for a new TCA feature",
    attributes: [
        nameAttribute,
        .optional("author", default: .string("Graham Hindle")),
        .optional("year", default: .string("2024")),
        .optional("date", default: .string("May 2024")),
        .optional("company", default: .string("Graham Hindle"))
    ],
    items: [
        .file(
            path: "\(nameAttribute)/Sources/\(nameAttribute)View.swift",
            templatePath: "TCAView.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Resources/Assets.xcassets/Contents.json",
            templatePath: "Resources.stencil"
        ),
        .file(
            path: "\(nameAttribute)/README.md",
            templatePath: "Readme.stencil"
        )
    ]
)

