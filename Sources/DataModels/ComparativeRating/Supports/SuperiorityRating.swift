public struct SuperiorityRating: ComparativeRating {
    public let superiority: BasicComparison
    public let benchmarkId: String?

    public init(superiority: BasicComparison, benchmarkId: String? = nil) {
        self.superiority = superiority
        self.benchmarkId = benchmarkId
    }
}
