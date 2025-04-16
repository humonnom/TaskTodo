import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.todos) { todo in
                        TodoItemView(item: todo, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("트리 구조 투두 리스트")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        viewModel.openAddSheet(for: nil)
                    }) {
                        Label("Epic 추가", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                AddItemView(
                    viewModel: viewModel,
                    parent: viewModel.selectedParent
                )
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
