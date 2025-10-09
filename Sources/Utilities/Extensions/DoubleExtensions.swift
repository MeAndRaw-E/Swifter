import Foundation

extension Double {
    public func rounded(toPlaces places: Int) -> Double {
        { (self * $0).rounded() / $0 }(pow(10.0, Double(places)))
    }
}
