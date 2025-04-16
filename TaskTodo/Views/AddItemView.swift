import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: TodoViewModel
    var parent: TodoItem?
    
    @State private var title: String = ""
    @State private var selectedType: TodoType
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: TodoViewModel, parent: TodoItem?) {
        self.viewModel = viewModel
        self.parent = parent
        
        // 부모 타입에 따라 기본 타입 설정
        let availableTypes = viewModel.getAvailableTypes(for: parent)
        _selectedType = State(initialValue: availableTypes.first ?? .epic)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("할 일 제목을 입력하세요", text: $title)
                        .padding(.vertical, 8)
                }
                
                let availableTypes = viewModel.getAvailableTypes(for: parent)
                if availableTypes.count > 1 {
                    Section(header: Text("타입")) {
                        Picker("타입", selection: $selectedType) {
                            ForEach(availableTypes, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(getNavigationTitle())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        if !title.isEmpty {
                            viewModel.addItem(title: title, type: selectedType, parent: parent)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func getNavigationTitle() -> String {
        if parent == nil {
            return "Epic 추가"
        } else if parent?.type == .epic {
            return "Story 추가"
        } else {
            return "Task 추가"
        }
    }
}
