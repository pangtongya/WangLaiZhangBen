import SwiftUI

// MARK: - 对比排行榜页
struct CompareView: View {
    @EnvironmentObject var vm: AccountViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                // 总付出排行
                RankSection(
                    title: "我付出最多",
                    subtitle: "按我给TA的钱排序",
                    persons: rankedByOut(),
                    valueKeyPath: \.out,
                    color: .red.opacity(0.8)
                )

                // 总收到排行
                RankSection(
                    title: "TA付出最多",
                    subtitle: "按TA给我的钱排序",
                    persons: rankedByIn(),
                    valueKeyPath: \.in,
                    color: .green.opacity(0.8)
                )

                // 净额排行
                RankSection(
                    title: "让我付出最多",
                    subtitle: "净差额从多到少",
                    persons: rankedByNet(),
                    valueKeyPath: \.net,
                    color: .blue
                )
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("对比")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 排名数据
    private func rankedByOut() -> [(Person, PersonStats)] {
        vm.persons.compactMap { p in
            let out = vm.totalOut(for: p.id)
            guard out > 0 else { return nil }
            return (p, PersonStats(out: out, in: vm.totalIn(for: p.id), net: vm.netAmount(for: p.id)))
        }
        .sorted { $0.1.out > $1.1.out }
    }

    private func rankedByIn() -> [(Person, PersonStats)] {
        vm.persons.compactMap { p in
            let `in` = vm.totalIn(for: p.id)
            guard `in` > 0 else { return nil }
            return (p, PersonStats(out: vm.totalOut(for: p.id), in: `in`, net: vm.netAmount(for: p.id)))
        }
        .sorted { $0.1.in > $1.1.in }
    }

    private func rankedByNet() -> [(Person, PersonStats)] {
        vm.persons.compactMap { p in
            let net = vm.netAmount(for: p.id)
            guard net != 0 else { return nil }
            return (p, PersonStats(out: vm.totalOut(for: p.id), in: vm.totalIn(for: p.id), net: net))
        }
        .sorted { $0.1.net < $1.1.net }  // 净额越小（付出越多）排前面
    }
}

// MARK: - 排名板块
private struct RankSection: View {
    let title: String
    let subtitle: String
    let persons: [(Person, PersonStats)]
    let valueKeyPath: KeyPath<PersonStats, Double>
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)

            if persons.isEmpty {
                Text("暂无数据")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(persons.enumerated()), id: \.element.0.id) { idx, item in
                        RankRow(
                            rank: idx + 1,
                            person: item.0,
                            stats: item.1,
                            value: item.1[keyPath: valueKeyPath],
                            color: color
                        )
                        if idx < persons.count - 1 {
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - 排名行
private struct RankRow: View {
    let rank: Int
    let person: Person
    let stats: PersonStats
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            // 排名徽章
            ZStack {
                if rank <= 3 {
                    Circle()
                        .fill(rank == 1 ? Color.orange : rank == 2 ? Color.gray : Color.brown)
                        .frame(width: 24, height: 24)
                    Text(["🥇","🥈","🥉"][rank-1])
                        .font(.caption2)
                } else {
                    Text("\(rank)")
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 28)

            // 人物头像
            Circle()
                .fill(Color(hex: person.colorHex))
                .frame(width: 32, height: 32)
                .overlay(Text(person.relationship.emoji).font(.caption))

            // 人物信息
            VStack(alignment: .leading, spacing: 2) {
                Text(person.name).font(.subheadline).fontWeight(.medium)
                Text(person.relationship.rawValue).font(.caption2).foregroundColor(.secondary)
            }

            Spacer()

            // 金额
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatAmount(value))
                    .font(.subheadline.bold())
                    .foregroundColor(color)
                if rank <= 3 {
                    Text(["最多付出","第二付出","第三付出"][rank-1])
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - 人物统计数据结构
private struct PersonStats {
    let out: Double
    let `in`: Double
    let net: Double
}

extension PersonStats: Identifiable {
    var id: String { "\(out)_\(`in`)_\(net)" }
}
