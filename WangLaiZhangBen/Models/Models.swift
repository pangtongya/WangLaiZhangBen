import Foundation
import SwiftUI

// MARK: - 关系类型
enum Relationship: String, Codable, CaseIterable, Identifiable {
    case current = "现任"
    case ex      = "前任"
    case ambiguous = "暧昧对象"
    case friend  = "朋友"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .current:    return "💕"
        case .ex:         return "💔"
        case .ambiguous:  return "🫦"
        case .friend:     return "🤝"
        }
    }

    var color: Color {
        switch self {
        case .current:    return .pink
        case .ex:         return .purple
        case .ambiguous:  return .orange
        case .friend:     return .blue
        }
    }
}

// MARK: - 人物档案
struct Person: Identifiable, Codable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var relationship: Relationship
    var colorHex: String   // 头像色块
    var isExample: Bool = false  // 是否为示例数据

    init(id: String = UUID().uuidString, name: String, relationship: Relationship, colorHex: String? = nil, isExample: Bool = false) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.colorHex = colorHex ?? Self.randomColor()
        self.isExample = isExample
    }

    static func randomColor() -> String {
        let colors = ["FF6B6B","4ECDC4","45B7D1","96CEB4","FFEAA7",
                      "DDA0DD","FF8C94","6C5CE7","FD79A8","A29BFE"]
        return colors.randomElement()!
    }
}

// MARK: - 账单类型
enum BillType: String, Codable, CaseIterable {
    case expense = "expense"
    case income = "income"
}

// MARK: - 账单记录
struct BillRecord: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var personId: String? = nil   // 关联人物，nil 表示无关联
    var type: String              // "expense" | "income"
    var direction: String = "out" // "out"=我给TA，"in"=TA给我（仅 personId 非空时有意义）
    var date: String              // "yyyy-MM-dd"
    var amount: Double
    var category: String
    var note: String
    var isExample: Bool = false   // 是否为示例数据
}

// MARK: - 分类
enum CategoryData {
    static let expenseCats: [(String, String)] = [
        ("餐饮", "🍽️"), ("交通", "🚗"), ("购物", "🛍️"), ("娱乐", "🎮"),
        ("住房", "🏠"), ("通讯", "📱"), ("医疗", "🏥"), ("教育", "📚"),
        ("人情", "🎁"), ("其他", "📌")
    ]

    static let incomeCats: [(String, String)] = [
        ("工资", "💰"), ("兼职", "💼"), ("理财", "📈"),
        ("报销", "🧾"), ("红包", "🧧"), ("其他", "📌")
    ]

    static func cats(for type: String) -> [(String, String)] {
        return type == "expense" ? expenseCats : incomeCats
    }

    static func emoji(for category: String) -> String {
        let all = expenseCats + incomeCats
        return all.first(where: { $0.0 == category })?.1 ?? "📌"
    }
}

// MARK: - 工具函数
func formatAmount(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    let numStr = formatter.string(from: NSNumber(value: abs(amount))) ?? "0.00"
    return "¥" + numStr
}

func formatChineseDate(_ dateStr: String) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    guard let date = df.date(from: dateStr) else { return dateStr }
    df.locale = Locale(identifier: "zh_CN")
    df.dateFormat = "yyyy年M月d日"
    return df.string(from: date)
}

func monthString(_ date: Date = Date()) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM"
    return df.string(from: date)
}
