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

            // Fretboard — centered in card
            FretboardView(voicing: voicing, cardColor: voicing.quality.color)
                .frame(width: cardWidth * 0.82, height: cardHeight * 0.58)

            // Top-left inversion label
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(voicing.inversion.shortLabel)
                    .font(.system(size: 36, weight: .bold))
                Text(voicing.inversion.rawValue)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.black.opacity(0.7))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 24)
            .padding(.top, 20)
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

            // Fretboard — centered in card
            FretboardView(voicing: voicing, cardColor: voicing.quality.color)
                .frame(width: cardWidth * 0.50, height: cardHeight * 0.80)

            // Top-left inversion label
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(voicing.inversion.shortLabel)
                    .font(.system(size: 32, weight: .bold))
                Text(voicing.inversion.rawValue)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.black.opacity(0.7))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 24)
            .padding(.top, 20)

            // Bottom-right quality letter
            Text(voicing.quality.abbreviation.prefix(1).uppercased())
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 24)
                .padding(.bottom, 20)
        }
        .frame(width: cardWidth, height: cardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
