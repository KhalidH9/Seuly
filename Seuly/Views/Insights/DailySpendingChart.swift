import Charts
import SwiftUI

/// Daily spend as columns: one hue, because the reader is comparing magnitude
/// rather than telling series apart. Grid and axes stay recessive.
struct DailySpendingChart: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: InsightsViewModel

    var body: some View {
        if !viewModel.analytics.dailySpend.isEmpty {
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    SeulySectionHeader(
                        title: L10n.text("daily.title", table: .insights),
                        subtitle: L10n.text("daily.subtitle", table: .insights)
                    )
                    chart
                }
            }
        }
    }

    private var chart: some View {
        Chart(viewModel.analytics.dailySpend) { item in
            BarMark(
                x: .value(
                    L10n.text("daily.day", table: .insights),
                    item.date,
                    unit: .day
                ),
                y: .value(
                    L10n.text("chart.spent", table: .insights),
                    majorUnits(item.amountMinor)
                )
            )
            .foregroundStyle(theme.chartSequential)
            .cornerRadius(4)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                if let date = value.as(Date.self) {
                    AxisValueLabel { Text(dayNumber(for: date)) }
                        .foregroundStyle(theme.chartAxis)
                }
            }
        }
        .chartYAxis {
            AxisMarks(
                position: .leading,
                values: .automatic(desiredCount: 4)
            ) { value in
                AxisGridLine().foregroundStyle(theme.chartGrid)
                if !viewModel.isPrivacyModeEnabled {
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            MoneyAmountText(
                                minorUnits: axisMinorUnits(amount),
                                currency: viewModel.currency,
                                compact: true,
                                symbolScale: .caption2
                            )
                        }
                    }
                    .foregroundStyle(theme.chartAxis)
                }
            }
        }
        .frame(height: 180)
        .accessibilityLabel(
            L10n.text("daily.accessibility", table: .insights)
        )
    }

    private func majorUnits(_ minorUnits: Int64) -> Double {
        viewModel.currency?.majorUnits(from: minorUnits) ?? 0
    }

    private func dayNumber(for date: Date) -> String {
        AppFormatters.integer(
            FinanceCalendar.current.component(.day, from: date)
        )
    }

    private func axisMinorUnits(_ amount: Double) -> Int64 {
        viewModel.currency?.minorUnits(fromMajorUnits: amount) ?? 0
    }
}
