import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    @StateObject private var expenseManager = ExpenseManager()
    @StateObject private var categoryManager = CategoryManager()
    @State private var showingAddEditExpense = false
    @State private var editingExpense: Expense?
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var expenseIndexSetToDelete: IndexSet?
    @State private var showingDeleteConfirmation = false
    @State private var selectedSortCriteria: SortCriteria = .date
    @State private var dateRange: DateRange?

    var filteredExpenses: [Expense] {
        let filteredByCategory = selectedCategory == "All" ? expenseManager.expenses : expenseManager.expenses.filter { $0.category == selectedCategory }
        let filteredBySearch = searchText.isEmpty ? filteredByCategory : filteredByCategory.filter {
            $0.category.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText) ||
            $0.paymentMethod.localizedCaseInsensitiveContains(searchText) ||
            $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
        return dateRange == nil ? filteredBySearch : filteredBySearch.filter { $0.date >= dateRange!.start && $0.date <= dateRange!.end }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search")
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    ForEach(categoryManager.categories, id: \.self) {
                        Text($0).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                DateRangePicker(dateRange: $dateRange)

                Picker("Sort by", selection: $selectedSortCriteria) {
                    Text("Date").tag(SortCriteria.date)
                    Text("Amount").tag(SortCriteria.amount)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedSortCriteria) { _ in
                    expenseManager.sortExpenses(by: selectedSortCriteria)
                }

                List {
                    ForEach(filteredExpenses) { expense in
                        NavigationLink(destination: ExpenseDetailView(expense: expense, manager: expenseManager)) {
                            VStack(alignment: .leading) {
                                Text(expense.category)
                                    .font(.headline)
                                Text("$\(expense.amount, specifier: "%.2f")")
                                Text(expense.paymentMethod)
                                HStack {
                                    ForEach(expense.tags, id: \.self) { tag in
                                        Text(tag)
                                            .padding(4)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                        .contextMenu {
                            Button("Edit") {
                                editingExpense = expense
                                showingAddEditExpense = true
                            }
                        }
                    }
                    .onDelete { indexSet in
                        expenseIndexSetToDelete = indexSet
                        showingDeleteConfirmation = true
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarItems(
                leading: NavigationLink(destination: CategoriesView(manager: categoryManager)) {
                    Image(systemName: "folder")
                },
                trailing: HStack {
                    NavigationLink(destination: SummaryView(manager: expenseManager)) {
                        Image(systemName: "chart.pie.fill")
                    }
                    Button(action: {
                        editingExpense = nil
                        showingAddEditExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
            .sheet(isPresented: $showingAddEditExpense) {
                AddEditExpenseView(manager: expenseManager, expense: editingExpense ?? Expense(category: "", amount: 0.0, description: "", date: Date(), paymentMethod: "", tags: []))
            }
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Expense"),
                    message: Text("Are you sure you want to delete this expense?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let indexSet = expenseIndexSetToDelete {
                            expenseManager.deleteExpense(at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct DateRangePicker: View {
    @Binding var dateRange: DateRange?

    var body: some View {
        HStack {
            DatePicker("From", selection: Binding(
                get: { dateRange?.start ?? Date() },
                set: { dateRange = DateRange(start: $0, end: dateRange?.end ?? $0) }
            ), displayedComponents: .date)
            DatePicker("To", selection: Binding(
                get: { dateRange?.end ?? Date() },
                set: { dateRange = DateRange(start: dateRange?.start ?? $0, end: $0) }
            ), displayedComponents: .date)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}
