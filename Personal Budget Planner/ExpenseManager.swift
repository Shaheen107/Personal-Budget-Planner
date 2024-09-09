import Foundation

//struct Expense: Identifiable, Codable {
//    var id = UUID()
//    var description: String
//    var amount: Double
//    var category: String
//    var date: Date
//}

class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
        }
    }

    init() {
        loadExpenses()
    }

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }

    func editExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func sortExpenses(by criteria: SortCriteria) {
        switch criteria {
        case .date:
            expenses.sort { $0.date < $1.date }
        case .amount:
            expenses.sort { $0.amount < $1.amount }
        }
    }

    func filterExpenses(by dateRange: DateRange?) -> [Expense] {
        guard let dateRange = dateRange else { return expenses }
        return expenses.filter { $0.date >= dateRange.start && $0.date <= dateRange.end }
    }

    private func saveExpenses() {
        if let data = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(data, forKey: "expenses")
        }
    }

    private func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: "expenses"),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
}

enum SortCriteria {
    case date, amount
}

struct DateRange {
    var start: Date
    var end: Date
}
