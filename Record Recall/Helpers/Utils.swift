//
//  Utils.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import Foundation

class Helper {
    static func getFriendlyDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdEEE")
        return dateFormatter.string(from: date)
    }
    
    static func getGreeting(from currentHour: Int? = nil) -> String {
        let hour = currentHour ?? Calendar.current.component(.hour, from: .now)
        // Morning 4 - 11:59
        // Afternoon 12 - 16:59
        // Evening 17 - 20:59
        // Night 21 - 23:59
        // Night 0 - 3:59
        
        let NEW_DAY = 0
        let MORNING_START = 4
        let AFTERNOON_START = 12
        let EVENING_START = 17
        let NIGHT_START = 21
        let MIDNIGHT = 24
        
        var greeting = "Hi"
        switch hour {
        case MORNING_START..<AFTERNOON_START:
            greeting = "Good morning"
        case AFTERNOON_START..<EVENING_START:
            greeting = "Good afternoon"
        case EVENING_START..<NIGHT_START:
            greeting = "Good evening"
        case NIGHT_START..<MIDNIGHT,
            NEW_DAY..<MORNING_START,
            MIDNIGHT:
            greeting = "It's a late night"
        default:
            _ = "Hello"
        }
        
        return greeting
    }
    
    static func weightValidator(newValue: String, weight: String) -> String {
        let regex = "^[0-9]{0,4}(?:\\.[0-9]{0,2})?$"
        var newWeight = weight
        if newValue.range(of: regex, options: .regularExpression) != nil {
            newWeight = newValue
        } else if !weight.isEmpty {
            newWeight = String(newValue.prefix(weight.count - 1))
        }
        //Mashing the keyboard like an idiot will
        // cause performance problems and let a character slide through
        // this stops that
        return newWeight
            .filter { "0123456789.".contains($0) }
    }
    
    static func repValidator(newValue: String, reps: String) -> String {
        let regex = "^[0-9]{0,3}?$"
        var newReps = reps
        if newValue.range(of: regex, options: .regularExpression) != nil {
            newReps = newValue
        } else if !reps.isEmpty {
            newReps = String(newValue.prefix(reps.count - 1))
        }
        //Mashing the keyboard like an idiot will
        // cause performance problems and let a character slide through
        // this stops that
        return newReps
            .filter { "0123456789".contains($0) }
    }
}


struct Metric: Codable {
    var name: String = "DoubleConverter"
    var value: Double
}

extension Metric: CustomStringConvertible {
    
    private static var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    var formattedValue: String {
        let number = NSNumber(value: value)
        var formattedValue = Self.valueFormatter.string(from: number)!
        
        
        while formattedValue.last == "0" {
            formattedValue.removeLast()
        }
        
        if formattedValue.last == "." {
            formattedValue.removeLast()
        }
        return formattedValue
    }
    
    var description: String {
        return "\(name): \(formattedValue)"
    }
}
