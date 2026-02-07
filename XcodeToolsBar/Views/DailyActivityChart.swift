import SwiftUI
import Charts

struct DailyActivityChart: View {
    let activities: [DailyActivity]

    var body: some View {
        Chart(activities) { activity in
            BarMark(
                x: .value("Date", activity.date, unit: .day),
                y: .value("Messages", activity.messageCount)
            )
            .foregroundStyle(.blue.gradient)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .frame(height: 120)
    }
}
