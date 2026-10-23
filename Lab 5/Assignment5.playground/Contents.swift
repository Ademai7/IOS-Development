// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Power Cell

// I use a class because one battery is mutable shared state, so every reference to the same PowerCell sees the same charge.
final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        if charge < 0 {
            self.charge = 0
        } else if charge > 100 {
            self.charge = 100
        } else {
            self.charge = charge
        }
    }

    func level() -> Int {
        return charge
    }

    func spend(_ amount: Int) -> Bool {
        if amount <= 0 {
            return false
        }

        if amount > charge {
            return false
        }

        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }

        charge += amount
        if charge > 100 {
            charge = 100
        }
    }
}

let cell = PowerCell(charge: 120)
print("PowerCell start:", cell.level())
print("Spend 25:", cell.spend(25), "level:", cell.level())
print("Spend 0:", cell.spend(0), "level:", cell.level())
cell.recharge(by: 40)
print("After recharge:", cell.level())

// Encapsulation proof:
// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1
class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int {
        return 10
    }

    var statusLine: String {
        return "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func performTask() -> Int {
        return 0
    }

    // final keeps every drone on the same safe routine: spend power first, then do the task.
    final func runOnce() -> Int {
        if cell.spend(powerCost) == false {
            return 0
        }

        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int {
        return 25
    }

    override func performTask() -> Int {
        return 40
    }

    func weldSeam() -> String {
        return "\(id) welded a seam."
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int {
        return 10
    }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }

    override func performTask() -> Int {
        return 15
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int {
        return 20
    }

    override func performTask() -> Int {
        return 25
    }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)

    switch kind {
    case "welder":
        return WelderDrone(id: id, cell: cell)
    case "scanner":
        return ScannerDrone(id: id, cell: cell)
    case "cargo":
        return CargoDrone(id: id, cell: cell)
    default:
        return nil
    }
}

var fleet: [Drone] = []

for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    } else {
        print("Skipped unknown drone kind: \(record.kind) (\(record.id))")
    }
}

print("Fleet built:", fleet.count, "drones")


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    var currentRound = 0

    while currentRound < rounds {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
        currentRound += 1
    }

    return totalWork
}

let A = runShift(fleet, rounds: 3)

var remainingCharge = 0
var canRunAgain = 0

for drone in fleet {
    print(drone.statusLine)
    remainingCharge += drone.cell.level()

    if drone.cell.level() >= drone.powerCost {
        canRunAgain += 1
    }
}

let B = remainingCharge
let C = canRunAgain

print("A =", A)
print("B =", B)
print("C =", C)


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

extension Drone: Diagnosable, Rechargeable {
    var componentID: String {
        return id
    }

    var statusCode: Int {
        return healthStatus(for: cell.level())
    }

    // Drone is a class, so it is a reference type. Its method can change shared state without the mutating keyword.
    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let componentID: String
    var chargeLevel: Int

    var statusCode: Int {
        return healthStatus(for: chargeLevel)
    }

    mutating func recharge(by amount: Int) {
        chargeLevel += amount
    }
}

var sensors: [SensorModule] = []

for data in sensorData {
    sensors.append(SensorModule(componentID: data.id, chargeLevel: data.charge))
}

// 4.3
func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = ""

    for component in components {
        report += component.diagnose()
        report += "\n"
    }

    return report
}

// [Drone] can only store Drone objects. SensorModule is a struct, so [Diagnosable] is what lets both kinds share one array.
var diagnosticsComponents: [Diagnosable] = []

for drone in fleet {
    diagnosticsComponents.append(drone)
}

for sensor in sensors {
    diagnosticsComponents.append(sensor)
}

print("Diagnostics before beacon:")
print(diagnosticsReport(diagnosticsComponents))


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
extension Diagnosable {
    func healthStatus(for level: Int) -> Int {
        if level < 20 {
            return 2
        }

        if level < 50 {
            return 1
        }

        return 0
    }

    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }
}

// 5.2 · the beacon you cannot edit
extension LegacyBeacon: Diagnosable {
    var componentID: String {
        return name
    }

    var statusCode: Int {
        return healthStatus(for: signalStrength)
    }

    func diagnose() -> String {
        return "\(componentID): LEGACY BEACON code \(statusCode)"
    }
}

diagnosticsComponents.append(beacon)

print("Diagnostics with beacon:")
print(diagnosticsReport(diagnosticsComponents))

var statusTotal = 0
for component in diagnosticsComponents {
    statusTotal += component.statusCode
}
let D = statusTotal
print("D =", D)

// 5.3
extension Int {
    var powerBar: String {
        var filled = self / 10

        if filled < 0 {
            filled = 0
        }

        if filled > 10 {
            filled = 10
        }

        var result = ""
        var position = 0

        while position < 10 {
            if position < filled {
                result += "#"
            } else {
                result += "."
            }
            position += 1
        }

        return result
    }
}

print("Power bar 42:", 42.powerBar)
print("Power bar -5:", (-5).powerBar)
print("Power bar 250:", 250.powerBar)


// MARK: Level 6 · Incident Reports
// The original reports from the starter file stay commented out because some of them do not compile.

/*
// Report 1
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}

// Report 2
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}

// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())

// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())
*/

// Report 1
// Expected: PatchDrone should replace performTask() and produce 30 work units.
// Actual: it does not compile because performTask() already comes from Drone.
// Rule: when a subclass replaces an inherited method, Swift requires the override keyword.
// Fix:
class PatchDrone: Drone {
    override func performTask() -> Int {
        return 30
    }
}

// Report 2
// Expected: HeavyWelder should inherit from WelderDrone and replace runOnce().
// Actual: it does not compile. WelderDrone is final, and runOnce() is final too.
// Rule: a final class cannot be subclassed, and a final method cannot be overridden.
// Fix: inherit from Drone and change the work, but keep the protected runOnce() routine.
final class HeavyWelder: Drone {
    override func performTask() -> Int {
        return 999
    }
}

// Report 3
// Expected: first is really a WelderDrone, so the author tried to call weldSeam().
// Actual: it does not compile because first has the declared type Drone, and Drone has no weldSeam().
// Rule: through a Drone reference, the compiler only exposes members declared on Drone.
// Fix: ask at runtime whether the object is a WelderDrone.
let reportFleetFixed: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let firstFixed = reportFleetFixed[0]

if let welder = firstFixed as? WelderDrone {
    print(welder.weldSeam())
}
// as? returns an optional because the runtime check can fail when the object is not a WelderDrone.

// Report 4
// Expected: the Thruster implementation should print "thruster T-1".
// Actual: in the original code it prints "generic component".
// Rule: label() was only in the protocol extension, not in the protocol requirements, so a Labelled value uses the extension version.
// Fix: make label() a protocol requirement. The extension can still provide a default implementation.
protocol Labelled {
    var componentID: String { get }
    func label() -> String
}

extension Labelled {
    func label() -> String {
        return "generic component"
    }
}

struct Thruster: Labelled {
    let componentID: String

    func label() -> String {
        return "thruster \(componentID)"
    }
}

let partsFixed: [Labelled] = [Thruster(componentID: "T-1")]
print(partsFixed[0].label())


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")




// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?

    A class is a reference type, so its methods can change the same object without using `mutating`. A struct is a value type, so a method that changes its stored properties has to be marked `mutating`.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:

    Inheritance lets a subclass reuse and override behaviour from one superclass.A protocol can connect unrelated types, for example our Drone class and SensorModule struct, as long as both meet the same requirements.

 3. What does `final` prevent, and what did it protect in runOnce()?

    `final` prevents further subclassing or overriding, depending on where it is used.Making runOnce() final protects the order of the shift: a drone must spend power first and only then perform its task.

 4. In Report 4, why did the protocol extension's method win?

    In the original code, label() was not a requirement of Labelled. It only existed in the protocol extension, so a value viewed as Labelled used that extension method. After label() becomes a protocol requirement, Thruster's own implementation is used.
*/

