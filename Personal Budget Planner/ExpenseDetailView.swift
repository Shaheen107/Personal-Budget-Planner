import SwiftUI

struct ExpenseDetailView: View {
    @State private var expense: Expense
    @ObservedObject var manager: ExpenseManager
    @State private var showingEditExpense = false
    
    init(expense: Expense, manager: ExpenseManager) {
        self._expense = State(initialValue: expense)
        self.manager = manager
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Category
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.blue)
                        Text(expense.category)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Amount
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                        Text("$\(expense.amount, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Description
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.purple)
                        Text(expense.description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Date
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.orange)
                        Text(expense.date, style: .date)
                            .font(.body)
                    }
                    
                    // Payment Method
                    HStack {
                        if #available(iOS 15.0, *) {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.teal)
                        } else {
                            // Fallback on earlier versions
                        }
                        Text("Payment Method: \(expense.paymentMethod)")
                            .font(.body)
                    }
                    
                    // Tags
                    if !expense.tags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags:")
                                .font(.headline)
                            ForEach(expense.tags, id: \.self) { tag in
                                HStack {
                                    Image(systemName: "tag")
                                        .foregroundColor(.gray)
                                    Text(tag)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .navigationTitle("Expense Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingEditExpense = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .sheet(isPresented: $showingEditExpense) {
                    EditExpenseView(expense: $expense, manager: manager)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(expense: Expense(category: "Food", amount: 25.50, description: "Dinner at Italian restaurant", date: Date(), paymentMethod: "Credit Card", tags: ["Dinner", "Restaurant"]), manager: ExpenseManager())
    }
}
