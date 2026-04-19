import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "guitars")
                            .font(.system(size: 48))
                            .foregroundColor(.primary)

                        Text("Guitar Triads")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)

                        Text("Choose a triad type to practice")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 40)

                    // Three quality options
                    VStack(spacing: 20) {
                        ForEach(TriadQuality.allCases) { quality in
                            NavigationLink(destination: CardDeckView(
                                quality: quality,
                                voicings: TriadDataProvider.voicings(for: quality)
                            )) {
                                QualityButton(quality: quality)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    // Footer
                    VStack(spacing: 4) {
                        Text("4 string sets • 3 inversions each")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text("12 cards per group • 36 total")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct QualityButton: View {
    let quality: TriadQuality

    private var icon: String {
        switch quality {
        case .major: return "hand.thumbsup.fill"
        case .minor: return "hand.thumbsdown.fill"
        case .diminished: return "circle.dotted"
        }
    }

    private var subtitle: String {
        switch quality {
        case .major: return "1 - 3 - 5"
        case .minor: return "1 - ♭3 - 5"
        case .diminished: return "1 - ♭3 - ♭5"
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(quality.color)
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(quality.rawValue)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("12")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(quality.color)
                Text("cards")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: quality.color.opacity(0.15), radius: 8, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(quality.color.opacity(0.3), lineWidth: 1.5)
        )
    }
}

#Preview {
    ContentView()
}
