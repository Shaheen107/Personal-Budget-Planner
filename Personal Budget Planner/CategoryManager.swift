import Foundation

class CategoryManager: ObservableObject {
    @Published var categories: [String] = ["Food", "Transport", "Entertainment", "Utilities"]

    init() {
        loadCategories()
    }

    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories.append(category)
            saveCategories()
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        saveCategories()
    }

    private func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }

    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") {
            categories = savedCategories
        }
    }
}
