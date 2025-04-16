import SwiftUI

struct TodoItemView: View {
    @ObservedObject var item: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                // 체크박스
                ZStack {
                    if item.completed {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 24, height: 24)
                    }
                }
                .onTapGesture {
                    viewModel.toggleComplete(item: item)
                }
                
                // 확장/축소 아이콘
                if !item.children.isEmpty {
                    Image(systemName: item.isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                        .onTapGesture {
                            viewModel.toggleExpand(item: item)
                        }
                } else if item.type == .task {
                    // Task인 경우 공간 유지
                    Spacer()
                        .frame(width: 16)
                }
                
                // 제목
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .strikethrough(item.completed)
                    .foregroundColor(item.completed ? .gray : .black)
                
                Spacer()
                
                // 타입 표시
                Text(item.type.rawValue)
                    .font(.system(size: 14))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(getTypeColor(type: item.type).opacity(0.2))
                    )
                    .foregroundColor(getTypeColor(type: item.type))
                
                // 추가 버튼
                if item.type != .task {
                    Button(action: {
                        viewModel.openAddSheet(for: item)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(8)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            
            // 하위 항목
            if item.isExpanded && !item.children.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(item.children) { child in
                        child.type == .task ? AnyView(
                            // Task 항목에 대한 특별 처리
                            TodoItemView(item: child, viewModel: viewModel)
                                .padding(.horizontal, 12)
                                .padding(.bottom, 4)
                        ) : AnyView(
                            // Story 항목
                            TodoItemView(item: child, viewModel: viewModel)
                                .padding(.leading, 12)
                        )
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .background(getBackgroundColor(type: item.type))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: item.type == .task ? Color.black.opacity(0.05) : Color.clear, radius: 2, x: 0, y: 1)
        .padding(.vertical, 4)
    }
    
    // 타입별 배경색 지정
    private func getBackgroundColor(type: TodoType) -> Color {
        switch type {
        case .epic:
            return Color(red: 0.95, green: 0.95, blue: 1.0)
        case .story:
            return Color(red: 0.9, green: 0.95, blue: 1.0)
        case .task:
            return Color.white
        }
    }
    
    // 타입별 텍스트 색상 지정
    private func getTypeColor(type: TodoType) -> Color {
        switch type {
        case .epic:
            return Color.purple
        case .story:
            return Color.blue
        case .task:
            return Color.gray
        }
    }
}
