import Foundation
import SwiftUI
import Combine

class AccountViewModel: ObservableObject {
    private let dm = DataManager.shared

    @Published var persons: [Person] = []
    @Published var bills:   [BillRecord] = []

    init() { load() }

    // MARK: - 加载（无数据时自动加载预设）
    func load() {
        var persons = dm.loadPersons()
        var bills   = dm.loadBills()
        if persons.isEmpty && bills.isEmpty {
            let preset = dm.loadPresetData()
            persons = preset.persons
            bills   = preset.bills
            dm.savePersons(persons)
            dm.saveBills(bills)
        }
        self.persons = persons
        self.bills   = bills
    }

    // MARK: - 人物 CRUD
    func addPerson(_ p: Person) {
        persons.append(p); dm.savePersons(persons); haptic(.light)
    }

    func updatePerson(_ p: Person) {
        if let idx = persons.firstIndex(where: { $0.id == p.id }) {
            persons[idx] = p; dm.savePersons(persons); haptic(.light)
        }
    }

    func deletePerson(_ p: Person) {
        persons.removeAll { $0.id == p.id }
        bills.removeAll { $0.personId == p.id }
        dm.savePersons(persons); dm.saveBills(bills); haptic(.light)
    }

    func person(by id: String) -> Person? {
        persons.first { $0.id == id }
    }

    // MARK: - 账单 CRUD
    func addBill(_ bill: BillRecord) {
        var b = bill
        while bills.contains(where: { $0.id == b.id }) { b.id = UUID().uuidString }
        bills.append(b); save(); haptic(.light)
    }

    func updateBill(_ bill: BillRecord) {
        if let idx = bills.firstIndex(where: { $0.id == bill.id }) {
            bills[idx] = bill; save(); haptic(.light)
        }
    }

    func deleteBill(_ bill: BillRecord) {
        bills.removeAll { $0.id == bill.id }; save(); haptic(.light)
    }

    // MARK: - 按人物统计
    func bills(for personId: String, in month: String? = nil) -> [BillRecord] {
        bills.filter {
            $0.personId == personId && (month == nil || $0.date.hasPrefix(month!))
        }
    }

    func totalOut(for personId: String, in month: String? = nil) -> Double {
        bills(for: personId, in: month)
            .filter { $0.direction == "out" }
            .reduce(0) { $0 + $1.amount }
    }

    func totalIn(for personId: String, in month: String? = nil) -> Double {
        bills(for: personId, in: month)
            .filter { $0.direction == "in" }
            .reduce(0) { $0 + $1.amount }
    }

    func netAmount(for personId: String, in month: String? = nil) -> Double {
        totalIn(for: personId, in: month) - totalOut(for: personId, in: month)
    }

    // MARK: - 按月统计（全部）
    func bills(in month: String) -> [BillRecord] {
        bills.filter { $0.date.hasPrefix(month) }
    }

    var currentMonth: String { monthString() }

    func totalExpense(in month: String) -> Double {
        bills(in: month).reduce(0) { sum, b in
            if b.personId == nil {
                return sum + (b.type == "expense" ? b.amount : 0)
            } else {
                return sum + (b.direction == "out" ? b.amount : 0)
            }
        }
    }

    func totalIncome(in month: String) -> Double {
        bills(in: month).reduce(0) { sum, b in
            if b.personId == nil {
                return sum + (b.type == "income" ? b.amount : 0)
            } else {
                return sum + (b.direction == "in" ? b.amount : 0)
            }
        }
    }

    func balance(in month: String) -> Double {
        totalIncome(in: month) - totalExpense(in: month)
    }

    func expenseByCategory(in month: String) -> [(String, Double)] {
        let filtered = bills(in: month).filter { $0.personId == nil && $0.type == "expense" }
        var dict: [String: Double] = [:]
        for b in filtered { dict[b.category, default: 0] += b.amount }
        return dict.sorted { $0.1 > $1.1 }
    }

    func incomeByCategory(in month: String) -> [(String, Double)] {
        let filtered = bills(in: month).filter { $0.personId == nil && $0.type == "income" }
        var dict: [String: Double] = [:]
        for b in filtered { dict[b.category, default: 0] += b.amount }
        return dict.sorted { $0.1 > $1.1 }
    }

    // MARK: - 清空所有数据
    func clearAll() {
        persons = []
        bills   = []
        dm.savePersons(persons)
        dm.saveBills(bills)
        haptic(.medium)
    }

    // MARK: - 示例数据管理
    var hasExampleData: Bool {
        persons.contains { $0.isExample } || bills.contains { $0.isExample }
    }

    func clearExampleData() {
        persons.removeAll { $0.isExample }
        bills.removeAll { $0.isExample }
        dm.savePersons(persons)
        dm.saveBills(bills)
        haptic(.medium)
    }

    // MARK: - 导出导入
    func exportAll() -> String? { dm.exportAll(persons: persons, bills: bills) }

    func importAll(from json: String) -> Bool {
        guard let (ps, bs) = dm.importAll(from: json) else { return false }
        persons = ps; bills = bs; dm.savePersons(ps); dm.saveBills(bs)
        haptic(.medium); return true
    }

    // MARK: - 内部
    private func save() { dm.saveBills(bills) }

    private func haptic(_ s: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: s).impactOccurred()
    }
}
