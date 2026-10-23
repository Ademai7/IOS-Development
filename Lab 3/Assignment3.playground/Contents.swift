import Cocoa


// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}


let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let splitResult = splitOnce(raw, by: ":"),
          splitResult.0.isEmpty == false,
          let value = Int(splitResult.1),
          value >= 0 || splitResult.0 == "TEMP"
    else {
        return nil
    }

    return (sensor: splitResult.0, value: value)
}

if let reading = parseReading("O2:87") {
    print(reading)
} else {
    print("nil")
}

if let reading = parseReading("TEMP:-12") {
    print(reading)
} else {
    print("nil")
}



// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var validReadings: [Reading] = []
    var invalidCount = 0

    for line in lines {
        if let reading = parseReading(line) {
            validReadings.append(reading)
        } else {
            invalidCount += 1
        }
    }

    return (valid: validReadings, invalidCount: invalidCount)
}

let parsedLog = parseLog(rawLog)
print(parsedLog)

let testLog = parseLog(["O2:50", "BAD", "TEMP:-5"])
print(testLog)


let A = parsedLog.invalidCount
print("A =", A)

// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var selectedReadings: [Reading] = []

    for reading in readings {
        if isIncluded(reading) {
            selectedReadings.append(reading)
        }
    }

    return selectedReadings
}

func values(of readings: [Reading]) -> [Int] {
    var readingValues: [Int] = []

    for reading in readings {
        readingValues.append(reading.value)
    }

    return readingValues
}



let o2Readings = select(parsedLog.valid) {
    $0.sensor == "O2"
}

print(o2Readings)

let tempReadings = select(parsedLog.valid) {
    $0.sensor == "TEMP"
}

print(tempReadings)



let o2Values = values(of: o2Readings)
print(o2Values)

let tempValues = values(of: tempReadings)
print(tempValues)



// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    if values.count == 0 {
        return nil
    }

    var minValue = values[0]
    var maxValue = values[0]
    var sum = 0

    for value in values {
        if value < minValue {
            minValue = value
        }

        if value > maxValue {
            maxValue = value
        }

        sum += value
    }

    let average = Double(sum) / Double(values.count)

    return (min: minValue, max: maxValue, average: average)
}


func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? { stats(of: values) }



let o2Stats = stats(of: o2Values)

if let result = o2Stats {
    print(result)
} else {
    print("nil")
}


let emptyArrayStats = stats(of: [])

if let result = emptyArrayStats {
    print(result)
} else {
    print("nil")
}



let variadicStats = stats(3, 8, 1)

if let result = variadicStats {
    print(result)
} else {
    print("nil")
}


let emptyVariadicStats = stats()

if let result = emptyVariadicStats {
    print(result)
} else {
    print("nil")
}



let B: Int

if let result = o2Stats {
    B = Int(result.average)
} else {
    B = 0
}

print("B =", B)



// 2.3 · The Closure Ladder (5 sorts, then compare results in code)

let sorted1 = parsedLog.valid.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

let sorted2 = parsedLog.valid.sorted(by: { a, b in
    return a.value > b.value
})

let sorted3 = parsedLog.valid.sorted(by: { a, b in
    a.value > b.value
})


let sorted4 = parsedLog.valid.sorted(by: {
    $0.value > $1.value
})


let sorted5 = parsedLog.valid.sorted {
    $0.value > $1.value
}



var allSortsMatch =
    sorted1.count == sorted2.count &&
    sorted1.count == sorted3.count &&
    sorted1.count == sorted4.count &&
    sorted1.count == sorted5.count

if allSortsMatch {
    for i in 0..<sorted1.count {
        if sorted1[i].sensor != sorted2[i].sensor ||
            sorted1[i].value != sorted2[i].value ||
            sorted1[i].sensor != sorted3[i].sensor ||
            sorted1[i].value != sorted3[i].value ||
            sorted1[i].sensor != sorted4[i].sensor ||
            sorted1[i].value != sorted4[i].value ||
            sorted1[i].sensor != sorted5[i].sensor ||
            sorted1[i].value != sorted5[i].value {

            allSortsMatch = false
            break
        }
    }
}

print("All five sorts match:", allSortsMatch)




// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    return t + 5
}

func coolDown(_ t: Int) -> Int {
    return t - 3
}

func hold(_ t: Int) -> Int {
    return t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    }

    if temp > 24 {
        return coolDown
    }

    return hold
}

print(heatUp(10))
print(heatUp(20))

print(coolDown(30))
print(coolDown(20))

print(hold(20))
print(hold(22))

let chosenForCold = chooseProtocol(for: 10)
print(chosenForCold(10))

let chosenForHot = chooseProtocol(for: 30)
print(chosenForHot(30))




// 3.2
func runUntilStable(
    from start: Int,
    maxSteps: Int = 10
) -> (finalTemp: Int, steps: Int, isStable: Bool) {

    var temperature = start
    var steps = 0

    while (temperature < 18 || temperature > 24) && steps < maxSteps {
        let protocolFunction = chooseProtocol(for: temperature)
        temperature = protocolFunction(temperature)
        steps += 1
    }

    let isStable = temperature >= 18 && temperature <= 24

    return (
        finalTemp: temperature,
        steps: steps,
        isStable: isStable
    )
}

print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))

let temperatureReadingsForC = select(parsedLog.valid) {
    $0.sensor == "TEMP"
}

let temperatureValuesForC = values(of: temperatureReadingsForC)

let C: Int

if let lowestTemperature = stats(of: temperatureValuesForC)?.min {
    C = runUntilStable(from: lowestTemperature).steps
} else {
    C = 0
}

print("C =", C)


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? { member.module?.oxygenTank?.level }

print(oxygenLevel(of: crew[0]) ?? -1)
print(oxygenLevel(of: crew[1]) ?? -1)



// 4.2
func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        let location = member.module?.name ?? "open space"
        return "\(member.name): no data (\(location))"
    }

    if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    }

    return "\(member.name): \(level)% OK"
}

for member in crew {
    print(status(of: member))
}



// 4.3
@discardableResult
func transferOxygen(
    from source: inout Int,
    to target: inout Int,
    amount: Int
) -> Int {

    if amount < 0 {
        return 0
    }

    if source <= 0 {
        return 0
    }

    if target >= 100 {
        return 0
    }

    var actualAmount = amount
    let availableSpace = 100 - target

    if actualAmount > source {
        actualAmount = source
    }

    if actualAmount > availableSpace {
        actualAmount = availableSpace
    }

    source -= actualAmount
    target += actualAmount

    return actualAmount
}

if let sourceTank = lab.oxygenTank,
   let targetTank = hab.oxygenTank {

    let transferred = transferOxygen(
        from: &sourceTank.level,
        to: &targetTank.level,
        amount: 30
    )

    print("Transferred:", transferred)
}

var testSource = 10
var testTarget = 95

let testTransfer = transferOxygen(
    from: &testSource,
    to: &testTarget,
    amount: 20
)

print(testTransfer)

let D = hab.oxygenTank?.level ?? 0
print("D =", D)

// 4.4
func evacuationOrder(
    _ names: String...,
    roster: [String: CrewMember]
) -> [String] {

    var foundMembers: [CrewMember] = []

    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }

        foundMembers.append(member)
    }

    let orderedMembers = foundMembers.sorted {
        $0.priority < $1.priority
    }

    var result: [String] = []

    for member in orderedMembers {
        result.append(member.name)
    }

    return result
}

print(
    evacuationOrder(
        "Dana",
        "Ghost",
        "Aigerim",
        "Timur",
        roster: roster
    )
)

print(
    evacuationOrder(
        "Nurlan",
        "Dana",
        roster: roster
    )
)


// MARK: Level 5 · The Saboteur's Logbook
// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.



//func reportOxygen(for member: CrewMember) -> String {
//    let tank = member.module!.oxygenTank!
//    return "\(member.name): \(tank.level)%"
//}
//
//func firstCritical(in crew: [CrewMember]) -> String {
//    var result: String?
//    for member in crew {
//        if oxygenLevel(of: member)! < 20 {
//            result = member.name
//        }
//    }
//    return result!
//}



// Problem 1:
/// In reportOxygen, member.module! can crash.
/// It breaks when a crew member has no module.
/// Example: Nurlan has module == nil.

// Problem 2:
/// In reportOxygen, oxygenTank! can crash.
/// It breaks when the member has a module, but that module has no oxygen tank.
/// Example: Dana is in Dock, and Dock has no oxygen tank.

// Problem 3:
/// In firstCritical, oxygenLevel(of: member)! can crash.
/// oxygenLevel returns nil when the member has no module
/// or when the module has no oxygen tank. Example: Dana and Nurlan.

// Problem 4:
/// result! can crash.
/// If there are no critical crew members, result stays nil.
/// For example, an empty crew or a crew where everyone has oxygen >= 20.

// Problem 5:
/// There is also a logic bug.
/// The function is called firstCritical, but it continues checking after finding a critical member.
/// If there are several critical members, it returns the last one, not the FIRST one.



func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }

    return "\(member.name): \(level)%"
}



print(reportOxygen(for: crew[0]))
print(reportOxygen(for: crew[1]))



func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member),
           level < 20 {
            return member.name
        }
    }

    return nil
}



print(firstCritical(in: crew) ?? "none")



let testModule1 = Module(
    name: "Test Module 1",
    oxygenTank: Tank(level: 10)
)

let testModule2 = Module(
    name: "Test Module 2",
    oxygenTank: Tank(level: 5)
)

let firstCriticalMember = CrewMember(
    name: "First",
    role: "Test",
    priority: 1,
    module: testModule1
)

let secondCriticalMember = CrewMember(
    name: "Second",
    role: "Test",
    priority: 2,
    module: testModule2
)

let criticalTestCrew = [
    firstCriticalMember,
    secondCriticalMember
]

print(firstCritical(in: criticalTestCrew) ?? "none")


// MARK: Finale · Launch Code

 let launchCode = "\(A)-\(B)-\(C)-\(D)"
 print("LAUNCH CODE: \(launchCode)")




// MARK: - ================= DEFENSE QUESTIONS =================

/*
1. guard let vs if let beyond syntax:

guard let is useful when I want to stop the function early if some data is missing.
If the guard succeeds, I can keep using the unwrapped value after it. With if let,
the value is usually used inside the if block, so the code can become more nested.

For example, in parseReading I can return nil immediately if the data is invalid,
and then continue with the valid data below the guard.


2. Why can't you pass [Int] to stats(_ values: Int...)?

Because Int... is a variadic parameter. When I call this function,
I have to pass separate Int values, for example: stats(3, 8, 1)

Inside the function Swift collects those values into an [Int].
If I already have an array, I should use:

stats(of: someArray)


3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

Both parameters are inout, so the function can change them. If I pass the same variable
as both source and target, Swift would have two inout accesses to the same
variable at the same time. Swift does not allow this because the changes could conflict.
For example, the function would try to subtract oxygen from x
and add oxygen to the same x during one call.


4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

oxygenLevel returns Int?, so the value after ?? also has to be an Int. "no data" is a String,
so the types do not match.
For example, this is valid:
oxygenLevel(of: dana) ?? 0


5. Full type of chooseProtocol and how to read it:

 (Int) -> ((Int) -> Int)

I read it like this: chooseProtocol takes an Int and returns another function.
That returned function also takes an Int and returns an Int.
*/

