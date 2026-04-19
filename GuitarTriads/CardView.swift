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
        }
        .frame(width: cardWidth, height: cardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
