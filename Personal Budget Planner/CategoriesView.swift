import SwiftUI

struct CategoriesView: View {
    @ObservedObject var manager: CategoryManager
    @State private var newCategory = ""
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                List {
                    ForEach(manager.categories, id: \.self) { category in
                        Text(category)
                    }
                    .onDelete(perform: manager.deleteCategory)
                    
                    HStack {
                        TextField("New Category", text: $newCategory)
                        Button("Add") {
                            if !newCategory.isEmpty {
                                manager.addCategory(newCategory)
                                newCategory = ""
                            }
                        }
                    }
                }
                .navigationTitle("Categories")
                .toolbar {
                    EditButton()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
