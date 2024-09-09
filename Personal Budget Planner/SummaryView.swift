import SwiftUI

struct SummaryView: View {
    @ObservedObject var manager: ExpenseManager

    var totalExpenses: Double {
        manager.expenses.reduce(0) { $0 + $1.amount }
    }

    var expensesByCategory: [String: Double] {
        Dictionary(grouping: manager.expenses, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    var expensesByPaymentMethod: [String: Double] {
        Dictionary(grouping: manager.expenses, by: { $0.paymentMethod })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    var expensesByTags: [String: Double] {
        manager.expenses.flatMap { expense in
            expense.tags.map { tag in (tag, expense.amount) }
        }
        .reduce(into: [String: Double]()) { result, entry in
            result[entry.0, default: 0] += entry.1
        }
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            VStack {
                Text("Total Expenses: $\(totalExpenses, specifier: "%.2f")")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    Section(header: Text("By Category")) {
                        ForEach(expensesByCategory.keys.sorted(), id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                Text("$\(expensesByCategory[category] ?? 0, specifier: "%.2f")")
                            }
                        }
                    }
                    
                    Section(header: Text("By Payment Method")) {
                        ForEach(expensesByPaymentMethod.keys.sorted(), id: \.self) { paymentMethod in
                            HStack {
                                Text(paymentMethod)
                                Spacer()
                                Text("$\(expensesByPaymentMethod[paymentMethod] ?? 0, specifier: "%.2f")")
                            }
                        }
                    }
                    
                    Section(header: Text("By Tags")) {
                        ForEach(expensesByTags.keys.sorted(), id: \.self) { tag in
                            HStack {
                                Text(tag)
                                Spacer()
                                Text("$\(expensesByTags[tag] ?? 0, specifier: "%.2f")")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Summary")
        } else {
            // Fallback on earlier versions
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(manager: ExpenseManager())
    }
}
