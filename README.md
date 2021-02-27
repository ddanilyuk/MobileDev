<p align="center">
    НАЦІОНАЛЬНИЙ ТЕХНІЧНИЙ УНІВЕРСИТЕТ УКРАЇНИ
</p>
<p align="center">
    “КИЇВСЬКИЙ ПОЛІТЕХНІЧНИЙ ІНСТИТУТ ІМЕНІ ІГОРЯ СІКОРСЬКОГО”
</p>
<p align="center">
    Факультет інформатики та обчислювальної техніки
</p>
<p align="center">
    Кафедра обчислювальної техніки
</p>
<br/>
<br/>
<br/>
<br/>
<p align="center">
    Лабораторна робота №2
</p>
<p align="center">
    з дисципліни “Програмування мобільних систем”
</p>

<br/>
<br/>
<br/>
<br/>
<br/>

<p align="right">
    Виконав:
</p>
<p align="right">
    студент групи ІВ-82
</p>
<p align="right">
    ЗК ІВ-8208
</p>
<p align="right">
    Данилюк Денис
</p>
<p align="center">
    Київ 2021
</p>

## Варіант № 1
(8208 mod 2) + 1 = 1

## Скріншоти роботи додатка

<img src="https://github.com/ddanilyuk/MobileDev/blob/lab/1.2/Images/lab1.2/1.png" width="1000">

## Лістинг роботи додатка

```swift
import Foundation

// MARK: - Частина 1

// Дано рядок у форматі "Student1 - Group1; Student2 - Group2; ..."

let studentsStr = "Дмитренко Олександр - ІП-84; Матвійчук Андрій - ІВ-83; Лесик Сергій - ІО-82; Ткаченко Ярослав - ІВ-83; Аверкова Анастасія - ІО-83; Соловйов Даніїл - ІО-83; Рахуба Вероніка - ІО-81; Кочерук Давид - ІВ-83; Лихацька Юлія - ІВ-82; Головенець Руслан - ІВ-83; Ющенко Андрій - ІО-82; Мінченко Володимир - ІП-83; Мартинюк Назар - ІО-82; Базова Лідія - ІВ-81; Снігурець Олег - ІВ-81; Роман Олександр - ІО-82; Дудка Максим - ІО-81; Кулініч Віталій - ІВ-81; Жуков Михайло - ІП-83; Грабко Михайло - ІВ-81; Іванов Володимир - ІО-81; Востриков Нікіта - ІО-82; Бондаренко Максим - ІВ-83; Скрипченко Володимир - ІВ-82; Кобук Назар - ІО-81; Дровнін Павло - ІВ-83; Тарасенко Юлія - ІО-82; Дрозд Світлана - ІВ-81; Фещенко Кирил - ІО-82; Крамар Віктор - ІО-83; Іванов Дмитро - ІВ-82"

// Завдання 1
// Заповніть словник, де:
// - ключ – назва групи
// - значення – відсортований масив студентів, які відносяться до відповідної групи

var studentsGroups: [String: [String]] = [:]

// Ваш код починається тут

let studentsWithGroups = studentsStr.components(separatedBy: "; ")
    .map { $0.components(separatedBy: " - ") }
    .map { (student: $0[0], group: $0[1]) }

// Version 1
studentsGroups = Dictionary(grouping: studentsWithGroups) { $0.group }.mapValues { $0.map { $0.student } }

// Version 2
studentsGroups = studentsWithGroups.reduce(into: [String: [String]]()) { result, newKey in
    var studentsArray = result[newKey.group] ?? []
    studentsArray.append(newKey.student)
    result[newKey.group] = studentsArray
}

// Ваш код закінчується тут

print("Завдання 1")
print(studentsGroups)
print()

// Дано масив з максимально можливими оцінками

let points: [Int] = [12, 12, 12, 12, 12, 12, 12, 16]

// Завдання 2
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – масив з оцінками студента (заповніть масив випадковими значеннями, використовуючи функцію `randomValue(maxValue: Int) -> Int`)

func randomValue(maxValue: Int) -> Int {
    switch(arc4random_uniform(6)) {
    case 1:
        return Int(ceil(Float(maxValue) * 0.7))
    case 2:
        return Int(ceil(Float(maxValue) * 0.9))
    case 3, 4, 5:
        return maxValue
    default:
        return 0
    }
}

var studentPoints: [String: [String: [Int]]] = [:]

// Ваш код починається тут

studentPoints = studentsGroups.mapValues { $0.reduce(into: [String: [Int]]()) { $0[$1] = Array(points.map { randomValue(maxValue: $0) }) } }

// Ваш код закінчується тут

print("Завдання 2")
print(studentPoints)
print()

// Завдання 3
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – сума оцінок студента

var sumPoints: [String: [String: Int]] = [:]

// Ваш код починається тут

sumPoints = studentPoints.mapValues { $0.mapValues { $0.reduce(0, +) } }

// Ваш код закінчується тут

print("Завдання 3")
print(sumPoints)
print()

// Завдання 4
// Заповніть словник, де:
// - ключ – назва групи
// - значення – середня оцінка всіх студентів групи

var groupAvg: [String: Float] = [:]

// Ваш код починається тут

groupAvg = sumPoints.mapValues { Float($0.values.reduce(0, +)) / Float($0.values.count) }

// Ваш код закінчується тут

print("Завдання 4")
print(groupAvg)
print()

// Завдання 5
// Заповніть словник, де:
// - ключ – назва групи
// - значення – масив студентів, які мають >= 60 балів

var passedPerGroup: [String: [String]] = [:]

// Ваш код починається тут

passedPerGroup = sumPoints.mapValues { $0.filter { $0.value >= 60 }.map { $0.key } }
// Ваш код закінчується тут

print("Завдання 5")
print(passedPerGroup)

// Приклад виведення. Ваш результат буде відрізнятися від прикладу через використання функції random для заповнення масиву оцінок та через інші вхідні дані.
//
//Завдання 1
//["ІВ-73": ["Гончар Юрій", "Давиденко Костянтин", "Капінус Артем", "Науменко Павло", "Чередніченко Владислав"], "ІВ-72": ["Бортнік Василь", "Киба Олег", "Овчарова Юстіна", "Тимко Андрій"], "ІВ-71": ["Андрющенко Данило", "Гуменюк Олександр", "Корнійчук Ольга", "Музика Олександр", "Трудов Антон", "Феофанов Іван"]]
//
//Завдання 2
//["ІВ-73": ["Давиденко Костянтин": [5, 8, 9, 12, 11, 12, 0, 0, 14], "Капінус Артем": [5, 8, 12, 12, 0, 12, 12, 12, 11], "Науменко Павло": [4, 8, 0, 12, 12, 11, 12, 12, 15], "Чередніченко Владислав": [5, 8, 12, 12, 11, 12, 12, 12, 15], "Гончар Юрій": [5, 6, 0, 12, 0, 11, 12, 11, 14]], "ІВ-71": ["Корнійчук Ольга": [0, 0, 12, 9, 11, 11, 9, 12, 15], "Музика Олександр": [5, 8, 12, 0, 11, 12, 0, 9, 15], "Гуменюк Олександр": [5, 8, 12, 9, 12, 12, 11, 12, 15], "Трудов Антон": [5, 0, 0, 11, 11, 0, 12, 12, 15], "Андрющенко Данило": [5, 6, 0, 12, 12, 12, 0, 9, 15], "Феофанов Іван": [5, 8, 12, 9, 12, 9, 11, 12, 14]], "ІВ-72": ["Киба Олег": [5, 8, 12, 12, 11, 12, 0, 0, 11], "Овчарова Юстіна": [5, 8, 12, 0, 11, 12, 12, 12, 15], "Бортнік Василь": [4, 8, 12, 12, 0, 12, 9, 12, 15], "Тимко Андрій": [0, 8, 11, 0, 12, 12, 9, 12, 15]]]
//
//Завдання 3
//["ІВ-72": ["Бортнік Василь": 84, "Тимко Андрій": 79, "Овчарова Юстіна": 87, "Киба Олег": 71], "ІВ-73": ["Капінус Артем": 84, "Науменко Павло": 86, "Чередніченко Владислав": 99, "Гончар Юрій": 71, "Давиденко Костянтин": 71], "ІВ-71": ["Корнійчук Ольга": 79, "Трудов Антон": 66, "Андрющенко Данило": 71, "Гуменюк Олександр": 96, "Феофанов Іван": 92, "Музика Олександр": 72]]
//
//Завдання 4
//["ІВ-71": 79.333336, "ІВ-72": 80.25, "ІВ-73": 82.2]
//
//Завдання 5
//["ІВ-72": ["Бортнік Василь", "Киба Олег", "Овчарова Юстіна", "Тимко Андрій"], "ІВ-73": ["Давиденко Костянтин", "Капінус Артем", "Чередніченко Владислав", "Гончар Юрій", "Науменко Павло"], "ІВ-71": ["Музика Олександр", "Трудов Антон", "Гуменюк Олександр", "Феофанов Іван", "Андрющенко Данило", "Корнійчук Ольга"]]

// MARK: - Частина 2

final class TimeDD {
    
    // MARK: - Public properties
    
    public let hours: UInt
    public let minutes: UInt
    public let seconds: UInt
    
    public var date: Date {
        return DateFormatter.h24Formatter.date(from: "\(hours):\(minutes):\(seconds)") ?? Date()
    }
    public var dateComponents: DateComponents {
        return DateComponents(hour: Int(hours), minute: Int(minutes), second: Int(seconds))
    }
    
    // MARK: - Lifecycle
    
    init() {
        hours = 0
        minutes = 0
        seconds = 0
    }
    
    init(hours: UInt, minutes: UInt, seconds: UInt) {
        
        self.hours = (0...23).contains(hours) ? hours : 0
        self.minutes = (0...59).contains(minutes) ? minutes : 0
        self.seconds = (0...59).contains(seconds) ? seconds : 0
    }
    
    init(date: Date) {
        
        hours = date.hours
        minutes = date.minutes
        seconds = date.seconds
    }
    
    // MARK: - Public methods
    
    public func currentTime(type: TimeType = .h12) -> String {
        
        return type.formatter.string(from: date)
    }
    
    public func sum(with item: TimeDD) -> TimeDD {
        
        return TimeDD(date: dateComponents.adding(to: item.date) ?? Date())
    }
    
    public func difference(with item: TimeDD) -> TimeDD {
        
        return TimeDD(date: item.dateComponents.removing(from: date) ?? Date())
    }
    
    // MARK: - Class methods
    
    static func +(lhs: TimeDD, rhs: TimeDD) -> TimeDD {
        return lhs.sum(with: rhs)
    }
    
    static func -(lhs: TimeDD, rhs: TimeDD) -> TimeDD {
        return lhs.difference(with: rhs)
    }
}

// MARK: - TimeType

extension TimeDD {
    
    enum TimeType {
        case h12
        case h24
        
        var formatter: DateFormatter {
            switch self {
            case .h12:
                return DateFormatter.h12Formatter
            case .h24:
                return DateFormatter.h24Formatter
            }
        }
    }
}

// MARK: - Date + Ext

extension Date {
    
    var hours: UInt {
        return UInt(Calendar.current.component(.hour, from: self))
    }
    
    var minutes: UInt {
        return UInt(Calendar.current.component(.minute, from: self))
    }
    
    var seconds: UInt {
        return UInt(Calendar.current.component(.second, from: self))
    }
}

// MARK: - DateFormatter + Ext

extension DateFormatter {
    
    static var h12Formatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter
    }
    
    static var h24Formatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
}

// MARK: - DateComponents + Ext

extension DateComponents {
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var reversed: DateComponents {
        
        return DateComponents(hour: -(hour ?? 0),
                              minute: -(minute ?? 0),
                              second: -(second ?? 0))
    }
    
    func adding(to date: Date) -> Date? {
        return calendar.date(byAdding: self, to: date)
    }
    
    func removing(from date: Date) -> Date? {
        return calendar.date(byAdding: reversed, to: date)
    }
}

// MARK: - Частина 2. Результати.

print("Частина 2")
print()

let time1 = TimeDD(date: Date())
let time2 = TimeDD()
let time3 = TimeDD(hours: 16, minutes: 2, seconds: 8)
let time4 = TimeDD(hours: 0, minutes: 0, seconds: 1)
let time5 = TimeDD(hours: 23, minutes: 59, seconds: 59)
let time6 = TimeDD(hours: 12, minutes: 0, seconds: 1)

print("Time1 12h: \(time1.currentTime()) | 24h: \(time1.currentTime(type: .h24))")
print("Time2 12h: \(time2.currentTime()) | 24h: \(time2.currentTime(type: .h24))")
print("Time3 12h: \(time3.currentTime()) | 24h: \(time3.currentTime(type: .h24))")
print("Time4 12h: \(time4.currentTime()) | 24h: \(time4.currentTime(type: .h24))")
print("Time5 12h: \(time5.currentTime()) | 24h: \(time5.currentTime(type: .h24))")
print("Time6 12h: \(time6.currentTime()) | 24h: \(time6.currentTime(type: .h24))")

print()

let sum = time5.sum(with: time6)
print("Sum with: \(time5.currentTime(type: .h24)) and \(time6.currentTime(type: .h24))")
print("Result 12h: \(sum.currentTime()) | 24h: \(sum.currentTime(type: .h24))")
print()

let difference = time2.difference(with: time4)
print("Difference with: \(time2.currentTime(type: .h24)) and \(time4.currentTime(type: .h24))")
print("Result 12h: \(difference.currentTime()) | 24h: \(difference.currentTime(type: .h24))")
print()

let sumClass = time2 + time4
print("Sum using class method with: \(time2.currentTime(type: .h24)) and \(time4.currentTime(type: .h24))")
print("Result 12h: \(sumClass.currentTime()) | 24h: \(sumClass.currentTime(type: .h24))")
print()

let differenceClass = time1 - time3
print("Difference using class method with: \(time1.currentTime(type: .h24)) and \(time3.currentTime(type: .h24))")
print("Result 12h: \(differenceClass.currentTime()) | 24h: \(differenceClass.currentTime(type: .h24))")

```

