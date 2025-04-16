import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var showingAddSheet = false
    @Published var selectedParent: TodoItem? = nil
    
    init() {
        self.todos = TodoData.getSampleData()
    }
    
    // 완료 상태 토글
    func toggleComplete(item: TodoItem) {
        item.completed.toggle()
        updateChildrenCompletionStatus(item: item, completed: item.completed)
    }
    
    // 하위 항목 완료 상태 업데이트
    private func updateChildrenCompletionStatus(item: TodoItem, completed: Bool) {
        for child in item.children {
            child.completed = completed
            updateChildrenCompletionStatus(item: child, completed: completed)
        }
    }
    
    // 확장 상태 토글
    func toggleExpand(item: TodoItem) {
        item.isExpanded.toggle()
    }
    
    // 새 항목 추가
    func addItem(title: String, type: TodoType, parent: TodoItem?) {
        let newItem = TodoItem(title: title, type: type)
        
        if let parent = parent {
            parent.children.append(newItem)
            parent.isExpanded = true
        } else {
            todos.append(newItem)
        }
    }
    
    // 부모 타입에 따라 추가 가능한 아이템 타입 결정
    func getAvailableTypes(for parent: TodoItem?) -> [TodoType] {
        if parent == nil {
            return [.epic]
        } else if parent?.type == .epic {
            return [.story]
        } else if parent?.type == .story {
            return [.task]
        }
        return []
    }
    
    // 새 항목 추가 시트 열기
    func openAddSheet(for parent: TodoItem?) {
        self.selectedParent = parent
        self.showingAddSheet = true
    }
}
