import SwiftUI

struct MeView: View {
    @EnvironmentObject var vm: AccountViewModel
    @State private var showImport = false
    @State private var importText = ""
    @State private var showAlert = false
    @State private var alertMsg = ""
    @State private var showPersonManage = false
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            List {
                // 人物档案
                Section("人物档案") {
                    if vm.persons.isEmpty {
                        HStack {
                            Spacer()
                            Text("还没有人物，点击下方管理添加")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    ForEach(vm.persons) { p in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: p.colorHex).opacity(0.4),
                                                 Color(hex: p.colorHex)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 32)
                                .overlay(Text(p.relationship.emoji).font(.caption))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.name).fontWeight(.medium)
                                Text(p.relationship.rawValue)
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            let out = vm.totalOut(for: p.id)
                            let `in` = vm.totalIn(for: p.id)
                            VStack(alignment: .trailing, spacing: 2) {
                                HStack(spacing: 3) {
                                    Image(systemName: "arrow.up").font(.system(size: 9))
                                    Text(String(format: "%.0f", out))
                                }
                                .font(.caption2).foregroundColor(.red.opacity(0.7))
                                HStack(spacing: 3) {
                                    Image(systemName: "arrow.down").font(.system(size: 9))
                                    Text(String(format: "%.0f", `in`))
                                }
                                .font(.caption2).foregroundColor(.green.opacity(0.7))
                            }
                        }
                    }
                    Button { showPersonManage = true } label: {
                        Label("管理人物", systemImage: "person.crop.circle")
                    }
                }

                // 数据总览
                Section("数据总览") {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue.opacity(0.7))
                        Text("人物数")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(vm.persons.count) 人")
                            .fontWeight(.medium)
                    }
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                            .foregroundColor(.orange.opacity(0.7))
                        Text("总账单")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(vm.bills.count) 笔")
                            .fontWeight(.medium)
                    }
                    let totalExp = vm.bills.reduce(0) { $0 + ($1.direction == "out" ? $1.amount : 0) }
                    let totalInc = vm.bills.reduce(0) { $0 + ($1.direction == "in" ? $1.amount : 0) }
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.red.opacity(0.6))
                        Text("总付出")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatAmount(totalExp))
                            .fontWeight(.medium).foregroundColor(.red.opacity(0.85))
                    }
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green.opacity(0.6))
                        Text("总收到")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatAmount(totalInc))
                            .fontWeight(.medium).foregroundColor(.green.opacity(0.8))
                    }
                }

                // 数据管理
                Section("数据管理") {
                    Button {
                        if let json = vm.exportAll() {
                            UIPasteboard.general.string = json
                            alertMsg = "数据已复制到剪贴板"
                            showAlert = true
                        }
                    } label: {
                        Label("导出数据", systemImage: "square.and.arrow.up")
                    }

                    Button {
                        showImport = true
                    } label: {
                        Label("导入数据", systemImage: "square.and.arrow.down")
                    }

                    Button(role: .destructive) {
                        showClearConfirm = true
                    } label: {
                        Label("清空所有数据", systemImage: "trash")
                    }
                }

                // 关于
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("我的")
            .sheet(isPresented: $showPersonManage) {
                PersonManageView()
                    .environmentObject(vm)
            }
            .alert("导入数据", isPresented: $showImport) {
                TextField("粘贴 JSON 数据", text: $importText)
                Button("取消", role: .cancel) { importText = "" }
                Button("导入") {
                    if vm.importAll(from: importText) {
                        alertMsg = "导入成功"
                    } else {
                        alertMsg = "数据格式错误"
                    }
                    showAlert = true
                    importText = ""
                }
            } message: {
                Text("导入将覆盖当前所有数据，请确认已备份。")
            }
            .alert("提示", isPresented: $showAlert) {
                Button("好") {}
            } message: {
                Text(alertMsg)
            }
            .alert("清空所有数据", isPresented: $showClearConfirm) {
                Button("取消", role: .cancel) {}
                Button("清空", role: .destructive) {
                    vm.clearAll()
                    alertMsg = "已清空所有数据"
                    showAlert = true
                }
            } message: {
                Text("将删除所有人物和账单记录，此操作不可撤销。")
            }
        }
    }
}

// MARK: - 人物管理页（复用 AddBillView 中定义的 PersonManageView）
// PersonManageView 和 PersonEditSheet 已在 AddBillView.swift 中定义
