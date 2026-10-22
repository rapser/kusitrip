import Foundation

extension Double {
    /// Formats an amount in the currency returned by the API, e.g. `US$ 331.74`.
    func kusiPrice(currency: String) -> String {
        let symbol = currency == "USD" ? "US$" : (currency == "PEN" ? "S/" : currency)
        return "\(symbol) \(String(format: "%.2f", self))"
    }
}
