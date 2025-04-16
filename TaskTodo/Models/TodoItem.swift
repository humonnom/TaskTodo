import Foundation

// 투두 아이템 타입 정의
enum TodoType: String, Codable, CaseIterable {
    case epic = "Epic"
    case story = "Story"
    case task = "Task"
}

// 투두 아이템 모델
class TodoItem: Identifiable, ObservableObject {
    let id: String
    @Published var title: String
    let type: TodoType
    @Published var completed: Bool
    @Published var children: [TodoItem]
    @Published var isExpanded: Bool
    
    init(id: String = UUID().uuidString, title: String, type: TodoType, completed: Bool = false, children: [TodoItem] = [], isExpanded: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.completed = completed
        self.children = children
        self.isExpanded = isExpanded
    }
}

// 샘플 데이터
class TodoData {
    static func getSampleData() -> [TodoItem] {
        let task1 = TodoItem(id: "task-1", title: "운동 계획 세우기", type: .task, completed: true)
        let task2 = TodoItem(id: "task-2", title: "운동복 구매하기", type: .task)
        let task3 = TodoItem(id: "task-3", title: "헬스장 등록하기", type: .task)
        
        let task4 = TodoItem(id: "task-4", title: "식단 계획 앱 설치하기", type: .task)
        let task5 = TodoItem(id: "task-5", title: "주간 식단 계획 세우기", type: .task)
        
        let task6 = TodoItem(id: "task-6", title: "Swift 기초 강의 수강", type: .task, completed: true)
        let task7 = TodoItem(id: "task-7", title: "토이 프로젝트 만들기", type: .task)
        
        let story1 = TodoItem(id: "story-1", title: "매주 3회 운동 루틴 만들기", type: .story, children: [task1, task2, task3], isExpanded: true)
        let story2 = TodoItem(id: "story-2", title: "건강한 식단 계획 세우기", type: .story, children: [task4, task5])
        
        let story3 = TodoItem(id: "story-3", title: "Swift 마스터하기", type: .story, children: [task6, task7])
        
        let epic1 = TodoItem(id: "epic-1", title: "2025년 건강한 라이프스타일 만들기", type: .epic, children: [story1, story2], isExpanded: true)
        let epic2 = TodoItem(id: "epic-2", title: "개발 역량 향상시키기", type: .epic, children: [story3])
        
        return [epic1, epic2]
    }
}
