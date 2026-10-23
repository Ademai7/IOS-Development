import Cocoa

///Easy Tasks

///Task 1 - Array Creation and Access:
let fruits = ["apple", "banana", "orange", "pear", "pineapple"]
print(fruits[2])



///Task 2 - Set Creation and Manipulation:
var setOfNumbers: Set<Int> = [1, 2, 3, 4, 5, 6]

setOfNumbers.insert(7)
print(setOfNumbers)



///Task 3 - Dictionary Creation and Access
let dictOfProgrammingLanguages = ["Swift": "2014", "Python": "1991", "C++": "1985"]
print(dictOfProgrammingLanguages["Swift"]!)



///Task 4 - Array Element Update
var arrayOfColors = ["red", "blue", "black", "purple"]
arrayOfColors[1] = "yellow"
print(arrayOfColors)




///Medium Tasks
///Task 1 - Set Intersection
let set1: Set<Int> = [1, 2, 3, 4]
let set2: Set<Int> = [3, 4, 5, 6]
print(set1.intersection(set2))


///Task 2 - Dictionary Update
var dictOfScores: [String: Int] = ["Ademay": 100, "Abay": 97, "Magzhan": 95]

dictOfScores["Magzhan"] = 100
print(dictOfScores)


///Task 3 - Array Merge
let arr1: [String] = ["apple", "banana"]
let arr2: [String] = ["cherry", "date"]
let merging = arr1 + arr2

print(merging)





///Hard Tasks
///Task 1 - Dictionary Key Addition   "Norway": 5_652_989,
var dictOfCountries: [String: String] = ["Kazakhstan": "20.6 million", "Switzerland": "9.0 million", "Spain": "47.85 million", "Italy": "58.93 million"]
dictOfCountries["Norway"] = "5.6 million"

print(dictOfCountries)


///Task 2 - Set Union and Subtract
let set11: Set<String> = ["cat", "dog"]
let set22: Set<String> = ["dog", "mouse"]
let unionOfSets = set11.union(set22)
let substructionOfSet2 = unionOfSets.subtracting(set22)

print(substructionOfSet2)


///Task 3 - Nested Collection
let dictOfGrades: [String: [Int] ] = ["Zere": [100, 99, 95], "Diana": [96, 90, 98], "Aziza": [97, 95, 93]]

print(dictOfGrades["Diana"]![1])

