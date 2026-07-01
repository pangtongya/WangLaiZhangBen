import SwiftUI

// MARK: - 人物切换栏
struct PersonBarView: View {
    @EnvironmentObject var vm: AccountViewModel
    @Binding var currentPid: String?
    @State private var showAdd = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(vm.persons) { p in
                    PersonChip(
                        person: p,
                        isSelected: currentPid == p.id
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            currentPid = p.id
                            haptic(.light)
                        }
                    }
                }

                // 添加按钮
                Button { showAdd = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showAdd) {
            PersonEditSheet(p: nil).environmentObject(vm)
        }
    }

    private func haptic(_ s: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: s).impactOccurred()
    }
}

// MARK: - 人物芯片
private struct PersonChip: View {
    @EnvironmentObject var vm: AccountViewModel
    let person: Person
    let isSelected: Bool
    let action: () -> Void
    @State private var showDeleteConfirm = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: person.colorHex))
                    .frame(width: 26, height: 26)
                    .overlay(
                        Text(person.relationship.emoji)
                            .font(.caption2)
                    )
                Text(person.name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? Color(hex: person.colorHex) : .primary)
            }
            .padding(.leading, 12)
            .padding(.trailing, 26)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(
                        isSelected
                        ? Color(hex: person.colorHex).opacity(0.12)
                        : Color(.systemGray6)
                    )
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected
                        ? Color(hex: person.colorHex).opacity(0.25)
                        : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .overlay(alignment: .topTrailing) {
            Button {
                showDeleteConfirm = true
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary.opacity(0.3))
                    .background(
                        Circle()
                            .fill(Color(.systemGroupedBackground))
                            .frame(width: 13, height: 13)
                    )
            }
            .offset(x: 5, y: -5)
        }
        .alert("删除「\(person.name)」", isPresented: $showDeleteConfirm) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                withAnimation(.spring(response: 0.3)) {
                    vm.deletePerson(person)
                }
            }
        } message: {
            Text("将同时删除该人物的所有账单记录，此操作不可撤销。")
        }
    }
}

// MARK: - 人物编辑 Sheet
struct PersonEditSheet: View {
    @EnvironmentObject var vm: AccountViewModel
    @Environment(\.dismiss) var dismiss
    var p: Person?

    @State private var name: String
    @State private var relationship: Relationship

    init(p: Person?) {
        self.p = p
        _name = State(initialValue: p?.name ?? "")
        _relationship = State(initialValue: p?.relationship ?? .current)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("姓名") {
                    TextField("请输入姓名", text: $name)
                }
                Section("关系") {
                    ForEach(Relationship.allCases) { rel in
                        HStack(spacing: 10) {
                            Text(rel.emoji).font(.title3)
                            Text(rel.rawValue)
                            Spacer()
                            if rel == relationship {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { relationship = rel }
                    }
                }
            }
            .navigationTitle(p == nil ? "新增人物" : "编辑人物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }.fontWeight(.bold)
                }
            }
        }
    }

    private func save() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if let p = p {
            var updated = p
            updated.name = trimmed
            updated.relationship = relationship
            vm.updatePerson(updated)
        } else {
            vm.addPerson(Person(name: trimmed, relationship: relationship))
        }
        dismiss()
    }
}

// MARK: - 人物管理页（供 MeView 使用）
struct PersonManageView: View {
    @EnvironmentObject var vm: AccountViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAdd = false
    @State private var editPerson: Person?

    var body: some View {
        List {
            ForEach(vm.persons) { p in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: p.colorHex))
                        .frame(width: 32, height: 32)
                        .overlay(Text(p.relationship.emoji).font(.caption))
                    VStack(alignment: .leading) {
                        Text(p.name).fontWeight(.medium)
                        Text(p.relationship.rawValue)
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { editPerson = p }
                .swipeActions {
                    Button(role: .destructive) { vm.deletePerson(p) } label: {
                        Label("删除", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("人物档案")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button { showAdd = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showAdd) {
            PersonEditSheet(p: nil).environmentObject(vm)
        }
        .sheet(item: $editPerson) { p in
            PersonEditSheet(p: p).environmentObject(vm)
        }
    }
}
