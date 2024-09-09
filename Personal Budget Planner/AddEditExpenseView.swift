import SwiftUI

struct AddEditExpenseView: View {
    @ObservedObject var manager: ExpenseManager
    @State var expense: Expense
    @Environment(\.presentationMode) var presentationMode
    @State private var newTag = ""

    var isEditing: Bool {
        manager.expenses.contains(where: { $0.id == expense.id })
    }

    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                Form {
                    TextField("Description", text: $expense.description)
                    TextField("Amount", value: $expense.amount, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $expense.category)
                    DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                    TextField("Payment Method", text: $expense.paymentMethod)
                    
                    Section(header: Text("Tags")) {
                        HStack {
                            TextField("New Tag", text: $newTag)
                            Button(action: {
                                if !newTag.isEmpty {
                                    expense.tags.append(newTag)
                                    newTag = ""
                                }
                            }) {
                                Text("Add")
                            }
                        }
                        ForEach(expense.tags, id: \.self) { tag in
                            Text(tag)
                        }
                        .onDelete { indexSet in
                            expense.tags.remove(atOffsets: indexSet)
                        }
                    }
                }
                .navigationTitle(isEditing ? "Edit Expense" : "Add Expense")
                .navigationBarItems(trailing: Button("Save") {
                    if isEditing {
                        manager.editExpense(expense)
                    } else {
                        manager.addExpense(expense)
                    }
                    presentationMode.wrappedValue.dismiss()
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
