import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    var category: String
    var amount: Double
    var description: String
    var date: Date
    var paymentMethod: String
    var tags: [String]
}
