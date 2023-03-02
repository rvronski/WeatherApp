//
//  TimeFormatter.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 06.02.2023.
//

import Foundation

var timezone: Int = 0

func unixTimeFormatter(time: Int) -> String {
    var correctTime = 0
    if timezone < 0 {
        correctTime = timezone + time
    } else {
        correctTime = time + timezone
    }
    let date = Date(timeIntervalSince1970: TimeInterval(correctTime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru")
    dateFormatter.dateFormat = "H:mm"
    dateFormatter.timeZone = .gmt
    let stringTime = dateFormatter.string(from: date)
    return stringTime
}

func dateFormatter(day: Int) -> String {
    var correctTime = 0
    if timezone < 0 {
        correctTime = timezone + day
    } else {
        correctTime = day + timezone
    }
    let date = Date(timeIntervalSince1970: TimeInterval(correctTime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru")
    dateFormatter.dateFormat = "d/MM E"
    dateFormatter.timeZone = .gmt
    let newDay = dateFormatter.string(from: date)
    return newDay
}

func moonPhaseFormatter(phase: Double) -> String {
    
    if phase == 1 || phase == 0 {
        return "Новая луна"
    } else if phase > 0 && phase < 0.5 {
        return "Растущая луна"
    } else if  phase == 0.5 {
        return "Полнолуние"
    }  else if phase > 0.5  {
        return "Убывающая луна"
    }
    return ""
}
