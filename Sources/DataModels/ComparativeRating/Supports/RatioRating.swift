import Observation

@Observable
public final class RatioRating: @unchecked Sendable, ComparativeRating {
    public let benchmarkId: String?
    public var subjectToBenchmarkRatio: Double

    public init(benchmarkId: String? = nil, subjectToBenchmarkRatio: Double) {
        self.benchmarkId = benchmarkId
        self.subjectToBenchmarkRatio = subjectToBenchmarkRatio
    }
}
