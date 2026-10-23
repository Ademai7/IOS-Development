import Cocoa

//Step 1:
let firstName: String = "Ademay"
let lastName: String = "Seilbelova"


//bonus challenge
let birthYear: Int = 2005
let currentYear: Int = 2026
let age: Int = currentYear - birthYear


let isStudent: Bool = true
var isStudentText: String = ""
if isStudent{
    isStudentText = "I am a student"
}

else {
    isStudentText = "I am not a student"
}


let height: Double = 1.71
let catName: String = "Ginger"
let myMotherFirstName: String = "Bibigul"
let myFatherFirstName: String = "Berik"
let mySisterFirstName: String = "Meruyert"
let myCatAge: Int = 8


//Step 2:
let favoriteHobby: String = "singing"
let numberOfHobbies: Int = 5
let favoriteNumber: Int=7
let isHobbyCreative: Bool = true
let energeticHobby: String = "dancing"
let relaxingHobby: String = "painting"
let creativeHobby = "editing the videos"
let productiveHobby: String = "reading"
let readingEmoji: String = "📚"


//bonus task Add an additonal variable for futureGoals (String), and append it to your life story (and any other interes4ng information related to you 🙂). Also try to use emoji as value of variables and variable names.

let futureGoals: String = "In the future, I want to work as game developer or maybe as an iOS developer."

let secretInfo: String = "Besides, since one of my hobbies is editing, I’ll tell you in secret that I have an account where I sometimes publish my work."



//Step 3

let lifeStory: String = "My name is \(firstName) \(lastName). \(isStudentText) and I am \(age) years old. I was born in \(birthYear) and my height is \(height) meters. I have a cute cat and his name is \(catName). He is \(myCatAge) years old. There are 4 people in our family. My mother's name is \(myMotherFirstName). My father's name is \(myFatherFirstName) and my sister's name is \(mySisterFirstName). Also, the \(favoriteHobby) brings me joy, that is why it is my favorite out of \(numberOfHobbies) hobbies of mine. I also like \(energeticHobby), \(relaxingHobby), \(creativeHobby), \(productiveHobby). When I am \(creativeHobby), my creative side is working quite well. I also like \(productiveHobby)\(readingEmoji) and \(relaxingHobby), because I find it relaxing. The hobby like \(energeticHobby) brings me joy because it gives me energy. My favorite number is \(favoriteNumber). I think because it is considered as a sacred number in our country's culture. \(futureGoals) \(secretInfo)"


//Step 4

print(lifeStory)




