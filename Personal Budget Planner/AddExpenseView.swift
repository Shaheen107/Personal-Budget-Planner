import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: ExpenseManager
    
    @State private var category = ""
    @State private var amount = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var paymentMethod = ""
    @State private var tags = ""
    
    @State private var showEmptyFieldAlert = false
    @State private var showSuccessAlert = false
    @State private var showInvalidAmountAlert = false
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                Form {
                    Section(header: Text("Expense Details")) {
                        TextField("Category", text: $category)
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $description)
                        TextField("Payment Method", text: $paymentMethod)
                        TextField("Tags (comma separated)", text: $tags)
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                }
                .navigationTitle("Add Expense")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // Check for empty fields
                            if category.isEmpty || amount.isEmpty || description.isEmpty || paymentMethod.isEmpty || tags.isEmpty {
                                showEmptyFieldAlert = true
                            } else if Double(amount) == nil {
                                // Check if amount is a valid number
                                showInvalidAmountAlert = true
                            } else {
                                let validAmount = Double(amount)!
                                let expense = Expense(
                                    category: category,
                                    amount: validAmount,
                                    description: description,
                                    date: date,
                                    paymentMethod: paymentMethod,
                                    tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                                )
                                manager.addExpense(expense)
                                showSuccessAlert = true
                            }
                        }
                    }
                }
                .alert(isPresented: $showEmptyFieldAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Please fill in all fields."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert(isPresented: $showInvalidAmountAlert) {
                    Alert(
                        title: Text("Invalid Amount"),
                        message: Text("Please enter a valid amount."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("Expense added successfully."),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(manager: ExpenseManager())
    }
}
