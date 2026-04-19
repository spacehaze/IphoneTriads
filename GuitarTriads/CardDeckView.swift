import SwiftUI

struct CardDeckView: View {
    let quality: TriadQuality
    let voicings: [TriadVoicing]
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                voicings[currentIndex].quality.color
                    .opacity(0.15)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Navigation bar
                    cardNavigationBar

                    // String set tabs
                    stringSetTabs
                        .padding(.top, 8)

                    // Card area with swipe
                    ZStack {
                        CardView(voicing: voicings[currentIndex])
                            .offset(x: dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            if value.translation.width < -threshold && currentIndex < voicings.count - 1 {
                                                currentIndex += 1
                                            } else if value.translation.width > threshold && currentIndex > 0 {
                                                currentIndex -= 1
                                            }
                                            dragOffset = 0
                                        }
                                    }
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Page dots
                    pageDots
                        .padding(.bottom, 16)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var cardNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17))
                }
                .foregroundColor(quality.color)
            }
            .padding(.leading, 16)

            Spacer()

            Text("\(quality.rawValue) Triads")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)

            Spacer()

            // Counter
            Text("\(currentIndex + 1)/\(voicings.count)")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.trailing, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var stringSetTabs: some View {
        let stringSets = StringSet.allSets
        let currentSet = voicings[currentIndex].stringSet
        let circleSize: CGFloat = 68

        return HStack(alignment: .center, spacing: 16) {
            ForEach(stringSets) { set in
                Button(action: {
                    if let idx = voicings.firstIndex(where: { $0.stringSet.id == set.id }) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            currentIndex = idx
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(currentSet.id == set.id ? quality.color : quality.color.opacity(0.15))
                            .frame(width: circleSize, height: circleSize)

                        Text(set.label)
                            .font(.system(size: 17, weight: currentSet.id == set.id ? .bold : .medium))
                            .foregroundColor(currentSet.id == set.id ? .white : quality.color)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var pageDots: some View {
        let stringSets = StringSet.allSets
        let currentSet = voicings[currentIndex].stringSet
        let currentSetVoicings = voicings.filter { $0.stringSet.id == currentSet.id }
        let indexInSet = currentSetVoicings.firstIndex(where: { $0.id == voicings[currentIndex].id }) ?? 0

        return VStack(spacing: 8) {
            // Inversion dots for current string set
            HStack(spacing: 8) {
                ForEach(0..<currentSetVoicings.count, id: \.self) { i in
                    Circle()
                        .fill(i == indexInSet ? quality.color : quality.color.opacity(0.3))
                        .frame(width: i == indexInSet ? 10 : 7, height: i == indexInSet ? 10 : 7)
                }
            }

            Text("Strings \(currentSet.label)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}
