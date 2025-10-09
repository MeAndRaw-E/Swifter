import Foundation

public enum TemporalContext: Codable {
    case specificTime(Date?)
    case timeInterval(startTime: Date?, endTime: Date?)

    private enum CodingKeys: String, CodingKey, SnakeCaseEnumeration { case startTime, endTime }

    public init(from d: Decoder) throws {
        if let c = try? d.container(keyedBy: CodingKeys.self), !c.allKeys.isEmpty {
            self = .timeInterval(
                startTime: try c.decodeIfPresent(Date.self, forKey: .startTime),
                endTime: try c.decodeIfPresent(Date.self, forKey: .endTime)
            )
        }
        else {
            self = .specificTime(try? d.singleValueContainer().decode(Date.self))
        }
    }

    public func encode(to enc: Encoder) throws {
        switch self {
        case .specificTime(let d):
            var c = enc.singleValueContainer()
            try c.encode(d)
        case let .timeInterval(s, e):
            var c = enc.container(keyedBy: CodingKeys.self)
            try c.encodeIfPresent(s, forKey: .startTime)
            try c.encodeIfPresent(e, forKey: .endTime)
        }
    }

    public var endTime: Date? {
        switch self {
        case .specificTime(let d), .timeInterval(_, let d): return d
        }
    }
}
