//
//  Extensions.swift
//  Weather-Forecast-App
//
//  Created by Bernardo Cervantes Mayagoitia on 8/30/23.
//

import Foundation
import SwiftUI

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

extension WeatherView {
    
    func GetTemperatureIcon(temp: String) -> String {
        guard let intTemp = Int(temp) else {return "thermometer.medium"}
        var result = ""
        
        if intTemp > 0 && intTemp <= 70 {
            result = "thermometer.low"
        }
        if intTemp > 70 && intTemp <= 90 {
            result = "thermometer.medium"
        }
        if intTemp > 90 {
            result = "thermometer.high"
        }
        
        return result
    }
    
    func getDate(addingDays: Int) -> String {
        let today = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: addingDays, to: today)!
        return "\(modifiedDate.formatted(.dateTime.month().day()))"
    }
}
