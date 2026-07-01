import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: AccountViewModel
    @State private var currentPid: String? = nil
    @State private var showGuide = false

    var body: some View {
        TabView {
            // 账本
            NavigationStack {
                BookView(currentPid: $currentPid)
            }
            .tabItem {
                Label("账本", systemImage: "book.closed.fill")
            }

            // 对比
            NavigationStack {
                CompareView()
            }
            .tabItem {
                Label("对比", systemImage: "chart.bar.fill")
            }

            // 我的
            NavigationStack {
                MeView()
            }
            .tabItem {
                Label("我的", systemImage: "person.circle.fill")
            }
        }
        .tint(.blue)
        .onAppear {
            // 默认选中第一个人物
            if currentPid == nil, let first = vm.persons.first {
                currentPid = first.id
            }
        }
        .onChange(of: vm.persons.count) { _, _ in
            // 人物变化时，如果当前选中的人物被删除了，切换到第一个
            if let pid = currentPid, !vm.persons.contains(where: { $0.id == pid }) {
                currentPid = vm.persons.first?.id
            }
            // 如果没有选中的人物，选中第一个
            if currentPid == nil, let first = vm.persons.first {
                currentPid = first.id
            }
        }
    }
}

// MARK: - 账本页
private struct BookView: View {
    @EnvironmentObject var vm: AccountViewModel
    @Binding var currentPid: String?
    @State private var showAddBill = false
    @State private var editBill: BillRecord?
    @State private var dismissBanner = false
    @State private var showClearConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            // 示例数据提示横幅
            if vm.hasExampleData && !dismissBanner {
                ExampleBanner { showClearConfirm = true }
            }

            // 人物切换栏
            PersonBarView(currentPid: $currentPid)

            // 当前人物内容
            if let pid = currentPid, let person = vm.person(by: pid) {
                BookContent(person: person, showAddBill: $showAddBill, editBill: $editBill)
            } else {
                EmptyStateView(
                    icon: "person.badge.plus",
                    title: "还没有人物档案",
                    subtitle: "点击上方 + 号添加现任或前任"
                )
            }
        }
        .navigationTitle("来记个账")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddBill) {
            if let pid = currentPid {
                AddBillView(personId: pid, editBill: nil).environmentObject(vm)
            }
        }
        .sheet(item: $editBill) { bill in
            AddBillView(personId: bill.personId ?? "", editBill: bill).environmentObject(vm)
        }
        .alert("清除示例数据", isPresented: $showClearConfirm) {
            Button("取消", role: .cancel) {}
            Button("清除", role: .destructive) {
                vm.clearExampleData()
                dismissBanner = true
                // 如果当前选中的人物被清除了，切换到第一个非示例人物
                if let pid = currentPid, !vm.persons.contains(where: { $0.id == pid }) {
                    currentPid = vm.persons.first?.id
                }
            }
        } message: {
            Text("将清除所有示例人物和示例账单，不会影响您自己添加的数据。")
        }
    }
}

// MARK: - 账本内容
private struct BookContent: View {
    @EnvironmentObject var vm: AccountViewModel
    let person: Person
    @Binding var showAddBill: Bool
    @Binding var editBill: BillRecord?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 对比统计卡片
                PersonSummaryCard(person: person)

                // 账单列表
                let bills = vm.bills(for: person.id).sorted { $0.date > $1.date }
                if bills.isEmpty {
                    EmptyStateView(
                        icon: "doc.text",
                        title: "还没有记录",
                        subtitle: "点击下方按钮记第一笔账"
                    )
                    .padding(.top, 40)
                } else {
                    VStack(spacing: 0) {
                        ForEach(bills) { bill in
                            BillRowView(bill: bill, personName: person.name)
                                .contentShape(Rectangle())
                                .onTapGesture { editBill = bill }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        vm.deleteBill(bill)
                                    } label: {
                                        Label("删除", systemImage: "trash")
                                    }
                                }
                            Divider().padding(.leading, 60)
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
        .overlay(alignment: .bottomTrailing) {
            Button {
                showAddBill = true
                haptic(.light)
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            }
            .padding(24)
        }
    }

    private func haptic(_ s: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: s).impactOccurred()
    }
}

// MARK: - 人物统计卡片
private struct PersonSummaryCard: View {
    @EnvironmentObject var vm: AccountViewModel
    let person: Person

    var body: some View {
        let myOut = vm.totalOut(for: person.id)
        let taIn  = vm.totalIn(for: person.id)
        let total = myOut + taIn
        let myPct = total > 0 ? myOut / total : 0
        let taPct = total > 0 ? taIn / total : 0
        let net   = taIn - myOut

        VStack(spacing: 16) {
            // 人物信息行
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: person.colorHex).opacity(0.3),
                                     Color(hex: person.colorHex)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(person.relationship.emoji).font(.title3)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(person.name).font(.headline).fontWeight(.bold)
                    Text(person.relationship.rawValue)
                        .font(.caption)
                        .foregroundColor(Color(hex: person.colorHex))
                }
                Spacer()
            }

            if total > 0 {
                // 渐变色对比条
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(.systemGray5))
                                .frame(height: 12)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.red.opacity(0.6), Color.red.opacity(0.85)],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                                .frame(width: max(12, geo.size.width * CGFloat(myPct)), height: 12)
                        }
                    }
                    .frame(height: 12)

                    HStack {
                        Text("我付").font(.caption2).foregroundColor(.red.opacity(0.8))
                        Spacer()
                        Text("TA付").font(.caption2).foregroundColor(.green.opacity(0.8))
                    }
                    .padding(.horizontal, 2)
                }
            }

            // 金额两栏
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("我付出").font(.caption).foregroundColor(.secondary)
                    Text(formatAmount(myOut))
                        .font(.title2.bold())
                        .foregroundColor(Color.red.opacity(0.85))
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 1, height: 40)

                VStack(spacing: 4) {
                    Text("TA付出").font(.caption).foregroundColor(.secondary)
                    Text(formatAmount(taIn))
                        .font(.title2.bold())
                        .foregroundColor(Color.green.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
            }

            // 差额标签
            if total > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.caption2)
                    Text(net >= 0 ? "TA 多付了" : "我多付了")
                        .font(.caption)
                    Text(formatAmount(abs(net)))
                        .font(.caption.bold())
                        .foregroundColor(net >= 0 ? .green : .red.opacity(0.85))
                }
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        .padding(.horizontal, 16)
    }
}

// MARK: - 示例数据提示横幅
private struct ExampleBanner: View {
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.wave.fill")
                .font(.caption)
                .foregroundColor(.orange)
            Text("这些是示例数据，帮你快速了解怎么用")
                .font(.caption)
                .foregroundColor(.primary.opacity(0.8))
            Spacer()
            Button(action: onClear) {
                Text("清掉")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.08), Color.yellow.opacity(0.06)],
                startPoint: .leading, endPoint: .trailing
            )
        )
    }
}

// MARK: - 空状态
private struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 72, height: 72)
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            Text(title).font(.subheadline.weight(.medium)).foregroundColor(.secondary)
            Text(subtitle).font(.caption).foregroundColor(.secondary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }
}

// MARK: - 工具函数
private func haptic(_ s: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: s).impactOccurred()
}
