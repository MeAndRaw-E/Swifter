import Foundation

public func decimalToFraction(_ decimal: Double, allowedFractions: [String]? = nil) -> (Int, String?) {
    let wholePart = Int(decimal)
    let fractionalPart = decimal.truncatingRemainder(dividingBy: 1)
    if fractionalPart == 0 { return (wholePart, nil) }
    if let allowedFractions = allowedFractions {
        var (closestFraction, minDifference) = ("", Double.infinity)
        for fraction in allowedFractions {
            if let fractionValue = convertFractionToDouble(fraction),
                abs(fractionalPart - fractionValue) < minDifference
            {
                (minDifference, closestFraction) = (abs(fractionalPart - fractionValue), fraction)
            }
        }
        return (wholePart, closestFraction.isEmpty ? nil : closestFraction)
    }
    var (numerator, denominator) = (1, 1)
    while abs(Double(numerator) / Double(denominator) - fractionalPart) > 1e-6 {
        Double(numerator) / Double(denominator) < fractionalPart ? (numerator += 1) : (denominator += 1)
    }
    let gcd = greatestCommonDivisor(numerator, denominator)
    return (wholePart, "\(numerator / gcd)/\(denominator / gcd)")
}

public func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
    var (x, y) = (a, b)
    while y != 0 { (x, y) = (y, x % y) }
    return x
}

public func convertFractionToDouble(_ value: String) -> Double? {
    let parts = value.split(separator: "/")
    if parts.count == 2, let num = Double(parts[0]), let den = Double(parts[1]), den != 0 { return num / den }
    return Double(value)
}
