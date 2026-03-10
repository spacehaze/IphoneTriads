import SwiftUI

struct FretboardView: View {
    let voicing: TriadVoicing
    let cardColor: Color

    private let stringCount = 3
    private let nutThickness: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let fretCount = voicing.fretSpan + 1
            let stringSpacing = width / CGFloat(stringCount + 1)
            let fretSpacing = height / CGFloat(fretCount + 1)
            let dotRadius = min(stringSpacing, fretSpacing) * 0.32

            ZStack {
                // Fretboard background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.15))
                    .frame(
                        width: stringSpacing * CGFloat(stringCount - 1) + 20,
                        height: fretSpacing * CGFloat(fretCount) + 10
                    )
                    .position(x: width / 2, y: fretSpacing * 0.5 + fretSpacing * CGFloat(fretCount) / 2)

                // Nut (top bar)
                Rectangle()
                    .fill(Color.black)
                    .frame(
                        width: stringSpacing * CGFloat(stringCount - 1) + 16,
                        height: nutThickness
                    )
                    .position(x: width / 2, y: fretSpacing * 0.5)

                // Strings (vertical lines)
                ForEach(0..<stringCount, id: \.self) { s in
                    let x = stringSpacing * CGFloat(s + 1)
                    Path { path in
                        path.move(to: CGPoint(x: x, y: fretSpacing * 0.5))
                        path.addLine(to: CGPoint(x: x, y: fretSpacing * CGFloat(fretCount) + fretSpacing * 0.5))
                    }
                    .stroke(Color.black, lineWidth: 2.5)
                }

                // Frets (horizontal lines)
                ForEach(0...fretCount, id: \.self) { f in
                    let y = fretSpacing * CGFloat(f) + fretSpacing * 0.5
                    Path { path in
                        let leftX = stringSpacing - 8
                        let rightX = stringSpacing * CGFloat(stringCount) + 8
                        path.move(to: CGPoint(x: leftX, y: y))
                        path.addLine(to: CGPoint(x: rightX, y: y))
                    }
                    .stroke(Color.black, lineWidth: f == 0 ? 4 : 2)
                }

                // Note dots
                ForEach(0..<voicing.positions.count, id: \.self) { i in
                    let pos = voicing.positions[i]
                    let x = stringSpacing * CGFloat(pos.stringIndex + 1)
                    let y = fretSpacing * CGFloat(pos.fretOffset) + fretSpacing
                    let isRoot = pos.isRoot

                    ZStack {
                        Circle()
                            .fill(isRoot ? Color(red: 1.0, green: 0.25, blue: 0.35) : Color.black)
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

struct FretboardLightView: View {
    let voicing: TriadVoicing

    private let stringCount = 3

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let fretCount = voicing.fretSpan + 1
            let stringSpacing = width / CGFloat(stringCount + 1)
            let fretSpacing = height / CGFloat(fretCount + 1)
            let dotRadius = min(stringSpacing, fretSpacing) * 0.35

            ZStack {
                // Strings (vertical lines)
                ForEach(0..<stringCount, id: \.self) { s in
                    let x = stringSpacing * CGFloat(s + 1)
                    Path { path in
                        path.move(to: CGPoint(x: x, y: fretSpacing * 0.5))
                        path.addLine(to: CGPoint(x: x, y: fretSpacing * CGFloat(fretCount) + fretSpacing * 0.5))
                    }
                    .stroke(Color.black, lineWidth: 2.5)
                }

                // Frets (horizontal lines)
                ForEach(0...fretCount, id: \.self) { f in
                    let y = fretSpacing * CGFloat(f) + fretSpacing * 0.5
                    Path { path in
                        let leftX = stringSpacing - 8
                        let rightX = stringSpacing * CGFloat(stringCount) + 8
                        path.move(to: CGPoint(x: leftX, y: y))
                        path.addLine(to: CGPoint(x: rightX, y: y))
                    }
                    .stroke(Color.black.opacity(0.4), lineWidth: f == 0 ? 4 : 1.5)
                }

                // Note dots
                ForEach(0..<voicing.positions.count, id: \.self) { i in
                    let pos = voicing.positions[i]
                    let x = stringSpacing * CGFloat(pos.stringIndex + 1)
                    let y = fretSpacing * CGFloat(pos.fretOffset) + fretSpacing
                    let isRoot = pos.isRoot

                    ZStack {
                        Circle()
                            .fill(isRoot ? Color(red: 1.0, green: 0.2, blue: 0.35) : Color.black)
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
