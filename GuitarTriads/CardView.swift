import SwiftUI

struct CardView: View {
    let voicing: TriadVoicing
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        GeometryReader { geo in
            if isLandscape {
                landscapeCard(size: geo.size)
            } else {
                portraitCard(size: geo.size)
            }
        }
    }

    @ViewBuilder
    private func portraitCard(size: CGSize) -> some View {
        let cardWidth = size.width * 0.88
        let cardHeight = size.height * 0.82

        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 24)
                .fill(voicing.quality.color)
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(voicing.inversion.shortLabel)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Title
                Text(voicing.title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 4)

                // Fretboard
                FretboardView(voicing: voicing, cardColor: voicing.quality.color)
                    .frame(width: cardWidth * 0.82, height: cardHeight * 0.50)
                    .padding(.top, 12)

                Spacer()

                // Footer info
                VStack(spacing: 6) {
                    Text("Strings: \(voicing.stringSet.label)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))

                    HStack(spacing: 8) {
                        Text(voicing.quality.rawValue)
                            .font(.system(size: 18, weight: .bold))
                        Text("•")
                            .font(.system(size: 18, weight: .bold))
                        Text(voicing.inversion.rawValue)
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.white)
                }
                .padding(.bottom, 24)
            }

            // Bottom-right letter
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(voicing.quality.abbreviation.prefix(1).uppercased())
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.trailing, 24)
                        .padding(.bottom, 60)
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func landscapeCard(size: CGSize) -> some View {
        let cardWidth = size.width * 0.85
        let cardHeight = size.height * 0.90

        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(voicing.quality.color)
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)

            HStack(spacing: 0) {
                // Left side: info
                VStack(spacing: 12) {
                    Text(voicing.inversion.shortLabel)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))

                    Text(voicing.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    VStack(spacing: 4) {
                        Text("Strings: \(voicing.stringSet.label)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))

                        Text(voicing.quality.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Text(voicing.inversion.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text(voicing.quality.abbreviation.prefix(1).uppercased())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black.opacity(0.7))
                }
                .frame(width: cardWidth * 0.35)
                .padding(.vertical, 20)

                // Right side: fretboard
                FretboardView(voicing: voicing, cardColor: voicing.quality.color)
                    .frame(width: cardWidth * 0.55, height: cardHeight * 0.75)
                    .padding(.trailing, 16)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
