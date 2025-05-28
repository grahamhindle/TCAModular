import ComposableArchitecture
import Foundation

public struct NumberFactClient {
    public var fetch: (Int) async throws -> String
    
    public init(fetch: @escaping (Int) async throws -> String) {
        self.fetch = fetch
    }
}

public extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}

extension NumberFactClient: DependencyKey {
   
    public static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}
