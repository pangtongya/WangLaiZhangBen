import SwiftUI

struct SummaryCardView: View {
    let month: String
    @EnvironmentObject var vm: AccountViewModel

    private var expense: Double { vm.totalExpense(in: month) }
    private var income: Double { vm.totalIncome(in: month) }
    private var balance: Double { vm.balance(in: month) }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("支出")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(formatAmount(expense))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 36)
                .background(Color.white.opacity(0.3))

            VStack(spacing: 6) {
                Text("收入")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(formatAmount(income))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 36)
                .background(Color.white.opacity(0.3))

            VStack(spacing: 6) {
                Text("结余")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(formatAmount(abs(balance)))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(balance >= 0 ? .green : .red)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.5), Color(red: 0.15, green: 0.22, blue: 0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
