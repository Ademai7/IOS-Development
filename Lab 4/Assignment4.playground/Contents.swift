// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case medbay
    case engine

    var evacuationPriority: Int {
        switch self {
        case .bridge:
            return 1
        case .medbay:
            return 2
        case .lab:
            return 3
        case .engine:
            return 4
        case .cargo:
            return 5
        }
    }
}

for deck in Deck.allCases {
    print("\(deck.rawValue): priority \(deck.evacuationPriority)")
}

print("Bridge priority: \(Deck.bridge.evacuationPriority)")
print("Cargo priority: \(Deck.cargo.evacuationPriority)")

// 1.2
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let rawLevel = mass / 500

        if rawLevel >= 3 {
            return AlarmLevel(rawValue: 3) ?? .red
        }

        return AlarmLevel(rawValue: rawLevel) ?? .green
    }
}

print(AlarmLevel.level(forTotalMass: 0))
print(AlarmLevel.level(forTotalMass: 940))
print(AlarmLevel.level(forTotalMass: 4000))


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

let testCrate = ManifestEntry.crate(id: 101, massKg: 120)
let testContainer = ManifestEntry.container(code: "KZ-ALM-7", massKg: 340)
let testLivestock = ManifestEntry.livestock(
    species: "lab mice",
    count: 12,
    massPerUnitKg: 2
)
let testUnknown = ManifestEntry.unknown(raw: "???")

print(testCrate)
print(testContainer)
print(testLivestock)
print(testUnknown)

// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)

    if parts.count == 3 && parts[0] == "crate" {
        if let id = Int(parts[1]), let mass = Int(parts[2]) {
            return .crate(id: id, massKg: mass)
        }
    }

    if parts.count == 3 && parts[0] == "container" {
        if let mass = Int(parts[2]) {
            return .container(code: parts[1], massKg: mass)
        }
    }

    if parts.count == 4 && parts[0] == "livestock" {
        if let count = Int(parts[2]), let massPerUnit = Int(parts[3]) {
            return .livestock(
                species: parts[1],
                count: count,
                massPerUnitKg: massPerUnit
            )
        }
    }

    return .unknown(raw: line)
}

print(parseEntry("crate:101:120"))
print(parseEntry("container:KZ-ALM-7:340"))
print(parseEntry("livestock:lab mice:12:2"))
print(parseEntry("crate:104:abc"))
print(parseEntry("wrong:data"))

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg

    case .container(_, let massKg):
        return massKg

    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg

    case .unknown:
        return 0
    }
}

print(mass(of: .crate(id: 101, massKg: 120)))
print(mass(of: .livestock(species: "lab mice", count: 12, massPerUnitKg: 2)))

var totalMass = 0
var unknownCount = 0

for line in rawManifest {
    let entry = parseEntry(line)

    totalMass += mass(of: entry)

    switch entry {
    case .unknown:
        unknownCount += 1

    case .crate, .container, .livestock:
        break
    }
}

let A = totalMass

print("Total mass: \(totalMass)")
print("Unknown lines: \(unknownCount)")
print("A = \(A)")


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen -= amount

        if oxygen < 0 {
            oxygen = 0
        }
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(
            name: name,
            deck: .medbay,
            oxygen: 100
        )
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(
            name: name,
            deck: .bridge,
            oxygen: 100
        )
    }
}

var testCrew = CrewSnapshot.rookie(named: "Dana")

print(testCrew)

testCrew.breathe(30)
print(testCrew)

testCrew.move(to: .cargo)
print(testCrew)

testCrew.reviveInMedbay()
print(testCrew)

// 3.2
var roster: [CrewSnapshot] = []

for record in crewData {
    if let deck = Deck(rawValue: record.deck) {
        let crew = CrewSnapshot(
            name: record.name,
            deck: deck,
            oxygen: record.oxygen
        )

        roster.append(crew)
    } else {
        print("Warning: invalid deck \(record.deck) for \(record.name)")
    }
}

let crewRoster: [CrewSnapshot] = roster

print(crewRoster)
print("Crew count: \(crewRoster.count)")

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)
var originalSnapshot = crewRoster[0]
var copiedSnapshot = originalSnapshot

print("Copy test - original before: \(originalSnapshot)")
print("Copy test - copy before: \(copiedSnapshot)")

copiedSnapshot.breathe(10)

print("Copy test - original after: \(originalSnapshot)")
print("Copy test - copy after: \(copiedSnapshot)")



func changeSnapshot(_ snapshot: CrewSnapshot) {
    var changedSnapshot = snapshot
    changedSnapshot.breathe(10)

    print("Inside normal function: \(changedSnapshot)")
}

var normalSnapshot = crewRoster[1]

print("Normal function - before: \(normalSnapshot)")
changeSnapshot(normalSnapshot)
print("Normal function - after: \(normalSnapshot)")


func changeSnapshotInout(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(10)
}

var inoutSnapshot = crewRoster[2]

print("Inout function - before: \(inoutSnapshot)")
changeSnapshotInout(&inoutSnapshot)
print("Inout function - after: \(inoutSnapshot)")

// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    // CrewSnapshot gets a memberwise initializer automatically because it is a struct.
    // TeleportPod is a class, so we write its initializer ourselves.
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil {
            return false
        }

        if chargeLevel < 20 {
            return false
        }

        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        if let currentOccupant = occupant {
            chargeLevel -= 20
            occupant = nil
            return currentOccupant
        }

        return nil
    }
}

let testPod = TeleportPod(id: "TEST-1", chargeLevel: 100)
print("Test pod id: \(testPod.id)")
print("Test pod charge: \(testPod.chargeLevel)")

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod
let pod = TeleportPod(id: "P-1", chargeLevel: 100)

let timur = crewRoster[0]
let dana = crewRoster[1]
let nurlan = crewRoster[3]

pod.load(timur)
pod.fire()
print("Charge after Timur: \(pod.chargeLevel)")

pod.load(dana)
pod.fire()
print("Charge after Dana: \(pod.chargeLevel)")

pod.load(nurlan)
pod.fire()
print("Charge after Nurlan: \(pod.chargeLevel)")

pod.fire()
print("Charge after empty fire: \(pod.chargeLevel)")

let C = pod.chargeLevel
print("C = \(C)")

// 4.3 · Reference-semantics demonstration
// TeleportPod is a class: both variables refer to the same object.

let secondPod = pod

print("Pod before - pod: \(pod.chargeLevel)")
print("Pod before - secondPod: \(secondPod.chargeLevel)")

secondPod.chargeLevel = 10

print("Pod after - pod: \(pod.chargeLevel)")
print("Pod after - secondPod: \(secondPod.chargeLevel)")


// CrewSnapshot is a struct: the second variable gets its own copy.

var firstCrew = crewRoster[0]
var secondCrew = firstCrew

print("Crew before - firstCrew: \(firstCrew.oxygen)")
print("Crew before - secondCrew: \(secondCrew.oxygen)")

secondCrew.oxygen = 20

print("Crew after - firstCrew: \(firstCrew.oxygen)")
print("Crew after - secondCrew: \(secondCrew.oxygen)")

// Classes use reference semantics; structs use value semantics.



// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    let callSign: String
    var oxygenByDeck: [Deck: Int]

    var hullIntegrity: Int {
        willSet {
            print("Hull integrity: \(hullIntegrity) -> \(newValue)")
        }

        didSet {
            if hullIntegrity > 100 {
                hullIntegrity = 100
            }

            if hullIntegrity < 0 {
                hullIntegrity = 0
            }
        }
    }

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "Station \(callSign): total oxygen = \(totalOxygen), average oxygen = \(averageOxygen)"
    }()

    var totalOxygen: Int {
        var total = 0

        for (_, oxygen) in oxygenByDeck {
            total += oxygen
        }

        return total
    }

    var averageOxygen: Int {
        get {
            return totalOxygen / oxygenByDeck.count
        }

        set {
            for deck in Deck.allCases {
                if oxygenByDeck[deck] != nil {
                    oxygenByDeck[deck] = newValue
                }
            }
        }
    }

    init(callSign: String, hullIntegrity: Int) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity

        var readings: [Deck: Int] = [:]

        for reading in deckReadings {
            if let deck = Deck(rawValue: reading.deck) {
                readings[deck] = reading.oxygen
            }
        }

        self.oxygenByDeck = readings
    }
}



let station = Station(
    callSign: "ALMA-7",
    hullIntegrity: 100
)

let B = station.averageOxygen

print("Total oxygen: \(station.totalOxygen)")
print("Starting average oxygen: \(station.averageOxygen)")
print("B = \(B)")



print(station.fullDiagnostics)
print(station.fullDiagnostics)


let untouchedStation = Station(
    callSign: "ALMA-7 Backup",
    hullIntegrity: 100
)

print("Untouched station created: \(untouchedStation.callSign)")
print("Untouched station average: \(untouchedStation.averageOxygen)")



let setterTestStation = Station(
    callSign: "Setter Test",
    hullIntegrity: 100
)

print("Average before setter: \(setterTestStation.averageOxygen)")

setterTestStation.averageOxygen = 50

print("Average after setter: \(setterTestStation.averageOxygen)")


// 5.2 · The clamp trap: 130, then -40, then 55
station.hullIntegrity = 130
print("Hull integrity after 130: \(station.hullIntegrity)")

station.hullIntegrity = -40
print("Hull integrity after -40: \(station.hullIntegrity)")

station.hullIntegrity = 55
print("Hull integrity after 55: \(station.hullIntegrity)")

// Changing hullIntegrity inside its own didSet does not call didSet again,
// so the clamp does not create an infinite loop.




// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.


// Report 1
// Expected: Every crew member should lose 10 oxygen.
// Actual: member is only a copy, so the values in roster do not change.
// Rule: CrewSnapshot is a struct, so it uses value semantics.
// Fixed version:
var reportRoster = crewRoster

for index in 0..<reportRoster.count {
    reportRoster[index].oxygen -= 10
}

print(reportRoster[0].oxygen)


// Report 2
// Expected: Changing podB should not change podA.
// Actual: Both variables refer to the same TeleportPod object.
// Rule: Classes use reference semantics.
// Fixed version:
let reportPodA = TeleportPod(id: "A", chargeLevel: 100)
let reportPodB = TeleportPod(id: "B", chargeLevel: 100)

reportPodB.chargeLevel = 0

print("reportPodA charge: \(reportPodA.chargeLevel)")
print("reportPodB charge: \(reportPodB.chargeLevel)")
//
// Report 3
// Expected: add(_:) should add an entry.
// Actual: It does not compile because the method changes a struct property.
// Rule: A struct method that changes properties must be mutating.
// Fixed version:
struct Logbook {
    var entries: [String] = []

    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var reportLogbook = Logbook()

reportLogbook.add("Teleporter started")
print(reportLogbook.entries)

reportLogbook.add("Transfer completed")
print(reportLogbook.entries)
//
// Report 4
// Expected: Both let values were expected to behave the same way.
// Actual: snapshot.oxygen cannot change, but pod.chargeLevel can.
// Rule: let freezes the whole struct value, but for a class it freezes only the reference.
// Fixed version:
var reportSnapshot = CrewSnapshot.rookie(named: "Dana")
reportSnapshot.oxygen = 40
print("Snapshot oxygen: \(reportSnapshot.oxygen)")

let reportPod = TeleportPod(id: "B", chargeLevel: 50)
reportPod.chargeLevel = 10
print("Pod charge: \(reportPod.chargeLevel)")



// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {

    // private blocks outside code from directly replacing or changing the entry list.
    private var entries: [String] = []

    // private blocks outside code from changing the sealed state.
    private var isSealed: Bool = false

    var entryCount: Int {
        return entries.count
    }

    var transcript: String {
        var text = ""
        var number = 1

        for entry in entries {
            text += "\(number). \(entry)\n"
            number += 1
        }

        return text
    }

    func add(_ entry: String) {
        if isSealed {
            return
        }

        entries.append(entry)
    }

    func seal() {
        isSealed = true
    }

    // fileprivate blocks other files from calling this helper directly.
    fileprivate func auditText() -> String {
        return "Flight Recorder Audit:\n\(transcript)"
    }
}


// Free function using the fileprivate helper

func auditTranscript(of recorder: FlightRecorder) -> String {
    return recorder.auditText()
}


// Testing

let recorder = FlightRecorder()

recorder.add("Teleporter online")
recorder.add("Crew transfer started")

print("Entry count before seal: \(recorder.entryCount)")
print(recorder.transcript)

recorder.seal()

recorder.add("Fake history")

print("Entry count after sealed add attempt: \(recorder.entryCount)")
print(auditTranscript(of: recorder))


// Failed attempts from outside:

// recorder.entries = []
// Error: 'entries' is inaccessible due to 'private' protection level

// recorder.entries.append("Changed history")
// Error: 'entries' is inaccessible due to 'private' protection level

// recorder.isSealed = false
// Error: 'isSealed' is inaccessible due to 'private' protection level


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")





// MARK: - ================= DEFENSE QUESTIONS =================
/*
1. Why did CrewSnapshot get an initializer for free while TeleportPod did not?

CrewSnapshot is a struct, so Swift automatically gives it a memberwise initializer. TeleportPod is a class, so I had to write its initializer myself.


2. What does mutating do to self, and why do classes never need it?

mutating lets a struct method change its properties or replace self completely. Classes do not need it because their methods can already change var properties.


3. In Report 4 both values are let. What exactly does let freeze for a struct,
   and what does it freeze for a class?

For a struct, let freezes the whole value, so its properties cannot be changed. For a class, let freezes only the reference, but var properties inside the object can still change.


4. Why must a lazy property be var? When does lazy change behaviour, not just performance?

A lazy property must be var because its value is created later, on first access. For example, fullDiagnostics prints "Running full scan..." only if we actually access it.


5. private vs fileprivate: where in your FlightRecorder would private be too strict?

The audit helper needs fileprivate because auditTranscript is a free function outside FlightRecorder but in the same file. private would not let that function access it.
*/

