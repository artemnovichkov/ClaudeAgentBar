import SwiftUI
import StatsClient

struct ModelUsageView: View {
    let stats: StatsCache

    var body: some View {
        VStack(spacing: 4) {
            ForEach(stats.modelUsage.keys.sorted(), id: \.self) { name in
                if let usage = stats.modelUsage[name] {
                    HStack {
                        Text(shortModelName(name))
                            .font(.subheadline)
                        Spacer()
                        Text(usage, format: .tokens)
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func shortModelName(_ name: String) -> String {
        let parts = name.split(separator: "-")
        guard parts.count >= 4, parts[0] == "claude" else { return name }
        let family = parts[1].capitalized
        let version = "\(parts[2]).\(parts[3])"
        return "\(family) \(version)"
    }
}

private struct ModelUsageFormatStyle: FormatStyle {
    public func format(_ value: ModelUsage) -> String {
        let total = value.inputTokens + value.cacheReadInputTokens + value.cacheCreationInputTokens
        return total.formatted(.number.notation(.compactName))
    }
}

private extension FormatStyle where Self == ModelUsageFormatStyle {
    static var tokens: ModelUsageFormatStyle { .init() }
}

#Preview("Single model") {
    ModelUsageView(stats: .mock)
        .padding()
}

#Preview("Multiple models") {
    ModelUsageView(stats: .mockMultipleModels)
        .padding()
}
