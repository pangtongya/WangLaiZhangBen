import SwiftUI

struct BillRowView: View {
    let bill: BillRecord
    var personName: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            // 分类图标
            Text(CategoryData.emoji(for: bill.category))
                .font(.title3)
                .frame(width: 42, height: 42)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )

            // 中间信息
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(bill.category)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    if let name = personName {
                        Text(name)
                            .font(.caption2)
                            .foregroundColor(Color.blue.opacity(0.7))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.08))
                            .clipShape(Capsule())
                    }
                    // 方向标签
                    Text(bill.direction == "out" ? "我付" : "TA付")
                        .font(.caption2)
                        .foregroundColor(bill.direction == "out" ? .red.opacity(0.7) : .green.opacity(0.7))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (bill.direction == "out" ? Color.red : Color.green).opacity(0.08)
                        )
                        .clipShape(Capsule())
                }
                if !bill.note.isEmpty {
                    Text(bill.note)
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                        .lineLimit(1)
                }
            }

            Spacer()

            // 金额 + 日期
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatAmount(bill.amount))
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(
                        bill.direction == "out"
                            ? Color.red.opacity(0.85)
                            : Color.green.opacity(0.8)
                    )
                Text(formatChineseDate(bill.date))
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.6))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}
