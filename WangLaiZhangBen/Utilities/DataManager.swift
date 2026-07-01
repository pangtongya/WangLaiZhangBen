import Foundation

class DataManager {
    static let shared = DataManager()
    private let billsKey   = "bills_key"
    private let personsKey = "persons_key"

    // MARK: - 账单 CRUD
    func saveBills(_ bills: [BillRecord]) {
        guard let data = try? JSONEncoder().encode(bills) else { return }
        UserDefaults.standard.set(data, forKey: billsKey)
    }

    func loadBills() -> [BillRecord] {
        guard let data = UserDefaults.standard.data(forKey: billsKey),
              let bills = try? JSONDecoder().decode([BillRecord].self, from: data)
        else { return [] }
        return bills
    }

    // MARK: - 人物 CRUD
    func savePersons(_ persons: [Person]) {
        guard let data = try? JSONEncoder().encode(persons) else { return }
        UserDefaults.standard.set(data, forKey: personsKey)
    }

    func loadPersons() -> [Person] {
        guard let data = UserDefaults.standard.data(forKey: personsKey),
              let persons = try? JSONDecoder().decode([Person].self, from: data)
        else { return [] }
        return persons
    }

    // MARK: - 预设示例数据（首次打开时加载，点击横幅即可一键清除）
    func loadPresetData() -> (persons: [Person], bills: [BillRecord]) {
        let p1 = Person(name: "小美", relationship: .current, isExample: true)
        let p2 = Person(name: "前任小王", relationship: .ex, isExample: true)
        let persons = [p1, p2]

        let cal = Calendar.current
        let now = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"

        var bills: [BillRecord] = []

        // —— 小美（现任💕）—— 恋爱日常花销，有来有往 ——
        bills.append(BillRecord(personId: p1.id, type: "expense", direction: "out",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -1, to: now)!),
                               amount: 158.00, category: "餐饮", note: "我请她吃火锅", isExample: true))
        bills.append(BillRecord(personId: p1.id, type: "expense", direction: "out",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -3, to: now)!),
                               amount: 80.00, category: "娱乐", note: "一起看电影", isExample: true))
        bills.append(BillRecord(personId: p1.id, type: "expense", direction: "out",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -7, to: now)!),
                               amount: 520.00, category: "人情", note: "情人节发红包", isExample: true))
        bills.append(BillRecord(personId: p1.id, type: "income", direction: "in",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -2, to: now)!),
                               amount: 328.00, category: "购物", note: "她送我生日礼物", isExample: true))
        bills.append(BillRecord(personId: p1.id, type: "income", direction: "in",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -5, to: now)!),
                               amount: 42.00, category: "交通", note: "她帮我打车", isExample: true))

        // —— 前任小王（前任💔）—— 借款往来，算清楚 ——
        bills.append(BillRecord(personId: p2.id, type: "expense", direction: "out",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -20, to: now)!),
                               amount: 3000.00, category: "人情", note: "借给TA的，还没还完", isExample: true))
        bills.append(BillRecord(personId: p2.id, type: "income", direction: "in",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -10, to: now)!),
                               amount: 1000.00, category: "人情", note: "TA还了一部分", isExample: true))
        bills.append(BillRecord(personId: p2.id, type: "expense", direction: "out",
                               date: fmt.string(from: cal.date(byAdding: .day, value: -15, to: now)!),
                               amount: 186.00, category: "餐饮", note: "最后一次一起吃饭", isExample: true))

        return (persons, bills)
    }

    // MARK: - 导出（合并人物+账单）
    func exportAll(persons: [Person], bills: [BillRecord]) -> String? {
        struct ExportPayload: Codable {
            let persons: [Person]
            let bills: [BillRecord]
        }
        let payload = ExportPayload(persons: persons, bills: bills)
        guard let data = try? JSONEncoder().encode(payload) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - 导入
    func importAll(from jsonStr: String) -> (persons: [Person], bills: [BillRecord])? {
        guard let data = jsonStr.data(using: .utf8),
              let payload = try? JSONDecoder().decode(ImportPayload.self, from: data)
        else { return nil }
        return (payload.persons, payload.bills)
    }

    private struct ImportPayload: Codable {
        let persons: [Person]
        let bills: [BillRecord]
    }
}
