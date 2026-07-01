import SwiftUI

struct AddBillView: View {
    @EnvironmentObject var vm: AccountViewModel
    @Environment(\.dismiss) var dismiss

    var personId: String
    var editBill: BillRecord?

    @State private var myPayText: String    // 我付出
    @State private var taPayText: String    // TA付出
    @State private var category: String
    @State private var note: String
    @State private var date: Date
    @State private var showAlert = false
    @State private var alertMsg = ""

    init(personId: String, editBill: BillRecord? = nil) {
        self.personId = personId
        self.editBill = editBill
        if let eb = editBill {
            if eb.direction == "out" {
                _myPayText = State(initialValue: String(format: "%.2f", eb.amount))
                _taPayText = State(initialValue: "")
            } else {
                _myPayText = State(initialValue: "")
                _taPayText = State(initialValue: String(format: "%.2f", eb.amount))
            }
        } else {
            _myPayText = State(initialValue: "")
            _taPayText = State(initialValue: "")
        }
        _category  = State(initialValue: editBill?.category ?? "餐饮")
        _note      = State(initialValue: editBill?.note ?? "")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        _date = State(initialValue: editBill.flatMap { df.date(from: $0.date) } ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                // 金额对比输入
                Section {
                    HStack(spacing: 10) {
                        // 我付出
                        VStack(spacing: 8) {
                            Text("我付出")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 1) {
                                Text("¥").font(.body).foregroundColor(.red.opacity(0.7))
                                TextField("0", text: $myPayText)
                                    .keyboardType(.decimalPad)
                                    .font(.title3.monospacedDigit())
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        .frame(maxWidth: .infinity)

                        // 分隔装饰
                        VStack(spacing: 0) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                )
                        }
                        .frame(width: 36)

                        // TA付出
                        VStack(spacing: 8) {
                            Text("TA付出")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 1) {
                                Text("¥").font(.body).foregroundColor(.green.opacity(0.7))
                                TextField("0", text: $taPayText)
                                    .keyboardType(.decimalPad)
                                    .font(.title3.monospacedDigit())
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                } header: {
                    Text("金额").font(.subheadline)
                }

                // 分类
                Section {
                    let cats = [("餐饮","🍽️"),("交通","🚗"),("购物","🛍️"),("娱乐","🎮"),
                               ("住房","🏠"),("通讯","📱"),("医疗","🏥"),("教育","📚"),
                               ("人情","🎁"),("其他","📌")]
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 10) {
                        ForEach(cats, id: \.0) { cat in
                            VStack(spacing: 4) {
                                Text(cat.1).font(.title2)
                                Text(cat.0).font(.system(size: 11))
                                    .foregroundColor(category == cat.0 ? .white : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(category == cat.0 ? Color.blue : Color(.systemGray6))
                            )
                            .onTapGesture { category = cat.0 }
                        }
                    }
                } header: {
                    Text("分类").font(.subheadline)
                }

                // 备注 &amp; 日期
                Section {
                    TextField("备注（选填）", text: $note)
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "zh_CN"))
                } header: {
                    Text("详情").font(.subheadline)
                }
            }
            .navigationTitle(editBill == nil ? "记一笔" : "编辑")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }.fontWeight(.bold)
                }
            }
            .alert("提示", isPresented: $showAlert) {
                Button("好") {}
            } message: {
                Text(alertMsg)
            }
        }
    }

    private func save() {
        let myPay = Double(myPayText) ?? 0
        let taPay = Double(taPayText) ?? 0

        guard myPay > 0 || taPay > 0 else {
            alertMsg = "请至少输入一个金额"; showAlert = true; return
        }

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: date)

        if let eb = editBill {
            // 编辑：只保存有金额的那一条
            if myPay > 0 {
                var b = eb
                b.personId = personId
                b.type = "expense"; b.direction = "out"
                b.amount = myPay; b.category = category
                b.note = note; b.date = dateStr
                vm.updateBill(b)
            } else if taPay > 0 {
                var b = eb
                b.personId = personId
                b.type = "income"; b.direction = "in"
                b.amount = taPay; b.category = category
                b.note = note; b.date = dateStr
                vm.updateBill(b)
            }
        } else {
            // 新建：两边都有金额则存两条，只有一边则存一条
            if myPay > 0 {
                vm.addBill(BillRecord(personId: personId,
                                     type: "expense", direction: "out",
                                     date: dateStr, amount: myPay,
                                     category: category, note: note))
            }
            if taPay > 0 {
                vm.addBill(BillRecord(personId: personId,
                                     type: "income", direction: "in",
                                     date: dateStr, amount: taPay,
                                     category: category, note: note))
            }
        }
        dismiss()
    }
}
