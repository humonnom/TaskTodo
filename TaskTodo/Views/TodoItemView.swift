import SwiftUI

struct TodoItemView: View {
    @ObservedObject var item: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.completed ? .green : .gray)
                    .onTapGesture {
                        viewModel.toggleComplete(item: item)
                    }
                
                Text(item.title)
                    .strikethrough(item.completed)
                
                Spacer()
                
                if !item.children.isEmpty {
                    Image(systemName: item.isExpanded ? "chevron.down" : "chevron.right")
                        .onTapGesture {
                            viewModel.toggleExpand(item: item)
                        }
                }
                
                if item.type != .task {
                    Button(action: {
                        viewModel.openAddSheet(for: item)
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            
            if item.isExpanded {
                ForEach(item.children) { child in
                    TodoItemView(item: child, viewModel: viewModel)
                        .padding(.leading)
                }
            }
        }
    }
}
