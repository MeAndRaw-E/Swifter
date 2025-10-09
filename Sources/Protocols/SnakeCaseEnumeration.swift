import Foundation

public protocol SnakeCaseEnumeration: Codable, RawRepresentable where RawValue == String {}

extension SnakeCaseEnumeration {
    public var snakeCaseValue: String {
        rawValue.replacingOccurrences(of: "([a-z0-9])([A-Z])", with: "$1_$2", options: .regularExpression)
            .lowercased()
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let snakeCaseValue = try container.decode(String.self)
        self =
            try Self(
                rawValue: snakeCaseValue.split(separator: "_").enumerated().map {
                    $0 == 0 ? String($1) : $1.capitalized
                }.joined()
            )
            ?? {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid value: \(snakeCaseValue)"
                )
            }()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(snakeCaseValue)
    }
}
