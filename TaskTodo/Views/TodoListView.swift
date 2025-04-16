import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // 헤더
                Text("트리 구조 투두 리스트")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white)
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // 할 일 목록 헤더
                        HStack {
                            Text("할 일 목록")
                                .font(.system(size: 20, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.openAddSheet(for: nil)
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Epic 추가")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                        // 투두 아이템 목록
                        ForEach(viewModel.todos) { todo in
                            TodoItemView(item: todo, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $viewModel.showingAddSheet) {
                AddItemView(
                    viewModel: viewModel,
                    parent: viewModel.selectedParent
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
