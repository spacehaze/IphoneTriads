import SwiftUI

struct FretboardView: View {
    let voicing: TriadVoicing
    let cardColor: Color

    private let totalStrings = 6
    private let nutThickness: CGFloat = 6

    private func displayPosition(for notePosition: NotePosition) -> Int {
        let guitarString = voicing.stringSet.strings[notePosition.stringIndex]
        return 6 - guitarString
    }

    // String 1 = thinnest (high E), String 6 = thickest (low E)
    private func stringWidth(for guitarStringNumber: Int) -> CGFloat {
        switch guitarStringNumber {
        case 1: return 1.2
        case 2: return 1.8
        case 3: return 2.4
        case 4: return 3.0
        case 5: return 3.6
        case 6: return 4.4
        default: return 2.0
        }
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let fretCount = voicing.fretSpan + 1
            let stringSpacing = width / CGFloat(totalStrings + 1)
            let fretSpacing = height / CGFloat(fretCount + 1)
            let dotRadius = min(stringSpacing, fretSpacing) * 0.34

            let activePositions = Set(voicing.stringSet.strings.map { 6 - $0 })

            ZStack {
                // Nut (top bar)
                Rectangle()
                    .fill(Color.black)
                    .frame(
                        width: stringSpacing * CGFloat(totalStrings - 1) + 16,
                        height: nutThickness
                    )
                    .position(x: width / 2, y: fretSpacing * 0.5)

                // Strings (vertical lines) - all 6
                // Position 0 = leftmost = string 6 (thickest)
                // Position 5 = rightmost = string 1 (thinnest)
                ForEach(0..<totalStrings, id: \.self) { s in
                    let x = stringSpacing * CGFloat(s + 1)
                    let guitarStringNumber = 6 - s // 6 at leftmost, 1 at rightmost
                    let baseWidth = stringWidth(for: guitarStringNumber)
                    Path { path in
                        path.move(to: CGPoint(x: x, y: fretSpacing * 0.5))
                        path.addLine(to: CGPoint(x: x, y: fretSpacing * CGFloat(fretCount) + fretSpacing * 0.5))
                    }
                    .stroke(Color.black, lineWidth: baseWidth)
                }

                // Frets (horizontal lines)
                ForEach(0...fretCount, id: \.self) { f in
                    let y = fretSpacing * CGFloat(f) + fretSpacing * 0.5
                    Path { path in
                        let leftX = stringSpacing - 8
                        let rightX = stringSpacing * CGFloat(totalStrings) + 8
                        path.move(to: CGPoint(x: leftX, y: y))
                        path.addLine(to: CGPoint(x: rightX, y: y))
                    }
                    .stroke(Color.black, lineWidth: f == 0 ? 4 : 2)
                }

                // X marks on muted strings (above nut)
                ForEach(0..<totalStrings, id: \.self) { s in
                    if !activePositions.contains(s) {
                        let x = stringSpacing * CGFloat(s + 1)
                        let y = fretSpacing * 0.25
                        Text("x")
                            .font(.system(size: dotRadius * 0.9, weight: .bold))
                            .foregroundColor(.black.opacity(0.5))
                            .position(x: x, y: y)
                    }
                }

                // Note dots on correct strings
                ForEach(0..<voicing.positions.count, id: \.self) { i in
                    let pos = voicing.positions[i]
                    let displayPos = displayPosition(for: pos)
                    let x = stringSpacing * CGFloat(displayPos + 1)
                    let y = fretSpacing * CGFloat(pos.fretOffset) + fretSpacing
                    let isRoot = pos.isRoot

                    ZStack {
                        Circle()
                            .fill(isRoot ? Color(red: 1.0, green: 0.0, blue: 0.0) : Color.black)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: isRoot ? 3 : 0)
                            )
                            .frame(width: dotRadius * 2, height: dotRadius * 2)

                        Text(pos.label)
                            .font(.system(size: dotRadius * 1.1, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .position(x: x, y: y)
                }
            }
        }
    }
}
