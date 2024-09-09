import SwiftUI

struct EditExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var expense: Expense
    @ObservedObject var manager: ExpenseManager
    
    @State private var amount: String
    
    init(expense: Binding<Expense>, manager: ExpenseManager) {
        _expense = expense
        self.manager = manager
        _amount = State(initialValue: String(expense.wrappedValue.amount))
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                Form {
                    TextField("Category", text: $expense.category)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount) { newValue in
                            if let value = Double(newValue) {
                                expense.amount = value
                            }
                        }
                    TextField("Description", text: $expense.description)
                    DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                }
                .navigationTitle("Edit Expense")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if let value = Double(amount) {
                                expense.amount = value
                            }
                            manager.updateExpense(expense)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .onAppear {
            amount = String(expense.amount)
        }
    }
}
