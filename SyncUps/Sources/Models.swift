import Foundation
import IdentifiedCollections
import SwiftUI


public struct SyncUp: Equatable, Identifiable, Codable {
  public let id: UUID
  public var attendees: IdentifiedArrayOf<Attendee> = []
  public var duration: Duration = .seconds(60 * 5)
  public var meetings: IdentifiedArrayOf<Meeting> = []
  public var theme: Theme = .bubblegum
  public var title = ""


  public var durationPerAttendee: Duration {
    duration / attendees.count
  }
}


public struct Attendee: Equatable, Identifiable, Codable {
  public let id: UUID
  public var name = ""
}


public struct Meeting: Equatable, Identifiable, Codable {
  public let id: UUID
  public let date: Date
  public var transcript: String
}


public enum Theme: String, CaseIterable, Equatable, Identifiable, Codable {
  public var id: Self { self }
  
  case bubblegum
  case buttercup
  case indigo
  case lavender
  case magenta
  case navy
  case orange
  case oxblood
  case periwinkle
  case poppy
  case purple
  case seafoam
  case sky
  case tan
  case teal
  case yellow


  public var accentColor: Color {
    switch self {
    case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan,
        .teal, .yellow:
      return .black
    case .indigo, .magenta, .navy, .oxblood, .purple:
      return .white
    }
  }


  public var mainColor: Color { Color(rawValue, bundle: .module) }


  public var name: String { rawValue.capitalized }
}


extension SyncUp {
  public static let mock = SyncUp(
    id: SyncUp.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob"),
      Attendee(id: Attendee.ID(), name: "Blob Jr."),
      Attendee(id: Attendee.ID(), name: "Blob Sr."),
    ],
    title: "Point-Free Morning Sync"
  )
}