import SwiftUI

enum TriadQuality: String, CaseIterable, Identifiable {
    case major = "Major"
    case minor = "Minor"
    case diminished = "Diminished"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .major: return Color(red: 0.91, green: 0.30, blue: 0.24)
        case .minor: return Color(red: 0.20, green: 0.40, blue: 0.85)
        case .diminished: return Color(red: 0.55, green: 0.24, blue: 0.70)
        }
    }

    var abbreviation: String {
        switch self {
        case .major: return "maj"
        case .minor: return "min"
        case .diminished: return "dim"
        }
    }
}

enum Inversion: String, CaseIterable {
    case root = "Root position"
    case first = "1st inversion"
    case second = "2nd inversion"

    var shortLabel: String {
        switch self {
        case .root: return "R"
        case .first: return "1"
        case .second: return "2"
        }
    }
}

struct StringSet: Identifiable, Hashable {
    let id: String
    let strings: [Int]

    var label: String { id }

    static let set321 = StringSet(id: "321", strings: [3, 2, 1])
    static let set432 = StringSet(id: "432", strings: [4, 3, 2])
    static let set543 = StringSet(id: "543", strings: [5, 4, 3])
    static let set654 = StringSet(id: "654", strings: [6, 5, 4])

    static let allSets: [StringSet] = [.set321, .set432, .set543, .set654]
}

struct NotePosition {
    let stringIndex: Int   // 0 = lowest string in set, 1 = middle, 2 = highest
    let fretOffset: Int    // relative fret position (0 = lowest fret shown)
    let label: String      // "R", "3", "5", "b3", "b5"
    let isRoot: Bool
}

struct TriadVoicing: Identifiable {
    let id = UUID()
    let quality: TriadQuality
    let inversion: Inversion
    let stringSet: StringSet
    let positions: [NotePosition]
    let fretSpan: Int      // how many frets the shape spans

    var title: String {
        "\(inversion.rawValue) \(quality.abbreviation)"
    }

    var cardTitle: String {
        "\(quality.rawValue) - \(inversion.rawValue)"
    }
}

struct TriadDataProvider {
    // Note labels for each quality and inversion
    // Inversion order: [lowest string, middle string, highest string]
    private static func noteLabels(quality: TriadQuality, inversion: Inversion) -> [(String, Bool)] {
        switch (quality, inversion) {
        case (.major, .root):       return [("R", true),  ("3", false), ("5", false)]
        case (.major, .first):      return [("3", false), ("5", false), ("R", true)]
        case (.major, .second):     return [("5", false), ("R", true),  ("3", false)]
        case (.minor, .root):       return [("R", true),  ("b3", false), ("5", false)]
        case (.minor, .first):      return [("b3", false), ("5", false), ("R", true)]
        case (.minor, .second):     return [("5", false), ("R", true),  ("b3", false)]
        case (.diminished, .root):  return [("R", true),  ("b3", false), ("b5", false)]
        case (.diminished, .first): return [("b3", false), ("b5", false), ("R", true)]
        case (.diminished, .second):return [("b5", false), ("R", true),  ("b3", false)]
        }
    }

    // Compute relative fret offsets for each voicing on a given string set
    // Returns [lowString, midString, highString] fret offsets (normalized so min = 0)
    private static func fretOffsets(quality: TriadQuality, inversion: Inversion, stringSet: StringSet) -> [Int] {
        // Intervals between adjacent open strings (lower to higher pitch)
        // String 6→5: 5, 5→4: 5, 4→3: 5, 3→2: 4, 2→1: 5
        let stringIntervals: [Int: Int] = [
            6: 5, // 6→5
            5: 5, // 5→4
            4: 5, // 4→3
            3: 4, // 3→2
            2: 5  // 2→1
        ]

        let strings = stringSet.strings // e.g. [3, 2, 1] from low to high pitch
        let i1 = stringIntervals[strings[0]]! // interval: lowest → middle
        let i2 = stringIntervals[strings[1]]! // interval: middle → highest

        // Semitone intervals for each note relative to root
        let intervals: [String: Int] = [
            "R": 0, "3": 4, "b3": 3, "5": 7, "b5": 6
        ]

        let labels = noteLabels(quality: quality, inversion: inversion)
        let semitones = labels.map { intervals[$0.0]! }

        // Calculate absolute semitones from lowest note
        // lowest string note is at semitone s[0], middle at s[1], highest at s[2]
        // But we need to account for octave wrapping in inversions
        var absoluteSemitones: [Int] = [semitones[0]]
        for i in 1..<3 {
            var target = semitones[i]
            while target <= absoluteSemitones[i - 1] {
                target += 12
            }
            absoluteSemitones.append(target)
        }

        // Fret for each string: fret = (desired semitone from low string open) - (open string offset)
        // If lowest string is at fret f, its pitch = openPitch + f
        // Middle string at fret g, pitch = openPitch + i1 + g
        // We want: openPitch + f + absoluteSemitones[0] for lowest... wait

        // Let's use: all relative to lowest string at fret 0
        // lowest string fret = 0 → note = absoluteSemitones[0] semitones above some reference
        // middle string fret = absoluteSemitones[1] - absoluteSemitones[0] - i1
        // highest string fret = absoluteSemitones[2] - absoluteSemitones[0] - i1 - i2

        let f0 = 0
        let f1 = absoluteSemitones[1] - absoluteSemitones[0] - i1
        let f2 = absoluteSemitones[2] - absoluteSemitones[0] - i1 - i2

        let minFret = min(f0, f1, f2)
        return [f0 - minFret, f1 - minFret, f2 - minFret]
    }

    static func allVoicings() -> [TriadVoicing] {
        var voicings: [TriadVoicing] = []

        for stringSet in StringSet.allSets {
            for quality in TriadQuality.allCases {
                for inversion in Inversion.allCases {
                    let offsets = fretOffsets(quality: quality, inversion: inversion, stringSet: stringSet)
                    let labels = noteLabels(quality: quality, inversion: inversion)
                    let fretSpan = offsets.max()! - offsets.min()!

                    let positions = (0..<3).map { i in
                        NotePosition(
                            stringIndex: i,
                            fretOffset: offsets[i],
                            label: labels[i].0,
                            isRoot: labels[i].1
                        )
                    }

                    voicings.append(TriadVoicing(
                        quality: quality,
                        inversion: inversion,
                        stringSet: stringSet,
                        positions: positions,
                        fretSpan: max(fretSpan, 2)  // show at least 3 frets
                    ))
                }
            }
        }

        return voicings
    }

    static func voicings(for quality: TriadQuality) -> [TriadVoicing] {
        allVoicings().filter { $0.quality == quality }
    }
}
