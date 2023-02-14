//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 01.02.2023.
//

import Foundation
/*
{
  "coord": {
    "lon": 10.99,
    "lat": 44.34
  },
  "weather": [
    {
      "id": 501,
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "temp_min": 297.56,
    "temp_max": 300.05,
    "pressure": 1015,
    "humidity": 64,
    "sea_level": 1015,
    "grnd_level": 933
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.62,
    "deg": 349,
    "gust": 1.18
  },
  "rain": {
    "1h": 3.16
  },
  "clouds": {
    "all": 100
  },
  "dt": 1661870592,
  "sys": {
    "type": 2,
    "id": 2075663,
    "country": "IT",
    "sunrise": 1661834187,
    "sunset": 1661882248
  },
  "timezone": 7200,
  "id": 3163858,
  "name": "Zocca",
  "cod": 200
}
*/



struct WeatherCodable: Codable {
    var description: String?
    var icon: String?
}

struct MainCodable: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var humidity: Double?

    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
        
    }
}

struct WindCodable: Codable {
    var speed: Double?
}



struct Clouds: Codable {
    var all: Int?
}

struct Sys: Codable {
    var sunrise: Int?
    var sunset: Int?
}

struct WheatherAnswer: Codable {
    var weather: [WeatherCodable]
    var main: MainCodable?
    var wind: WindCodable?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var name: String?
}

struct List: Codable {
    var dt: Int?
    var main: MainCodable?
    var weather: [WeatherCodable]?
    var clouds: Clouds?
    var wind: WindCodable?
    var pop: Double?
    var dtTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case pop
        case dtTxt = "dt_txt"
    }
}

struct Temp: Codable {
    var day: Double
    var min: Double
    var max: Double
    var night: Double
}

struct FeelLike: Codable {
    var day: Double
    var night: Double
}

struct Daily: Codable {
    var sunrise: Int?
    var sunset: Int?
    var moonrise: Int?
    var moonset: Int?
    var moonPhase: Double?
    var dt: Int?
    var temp: Temp?
    var feelsLike: FeelLike?
    var pressure: Int?
    var humidity: Int?
    var windSpeed: Double?
    var weather: [WeatherCodable]?
    var clouds: Int?
    var uvi: Double?
    var pop: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case windSpeed = "wind_speed"
        case weather
        case clouds
        case uvi
        case pop
       
    }
}

struct DailyAnswer: Codable {
    var daily: [Daily]?
    
}

struct SoonAnswer: Codable {
    var list: [List]
}


func getNowWeather(lat:Double, lon: Double,  completion: @escaping (WheatherAnswer) -> Void) {
    let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=b896c16fafb3a47b68b0a51b99fa50f2&lang=ru&units=metric"
    guard let url = URL(string: urlString) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            return
        }
        guard let data else {
            print("data = nil")
            return
        }
        do {
           let answer = try JSONDecoder().decode(WheatherAnswer.self, from: data)
            completion(answer)
            print(answer)
        } catch {
            print(error)
        }
    }
    task.resume()
}
//api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}

func weatherSoon(lat:Double, lon: Double, completion: @escaping (_ list: [List]) -> Void) {
    let urlString =  "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=b896c16fafb3a47b68b0a51b99fa50f2&lang=ru&units=metric"
    guard let url = URL(string: urlString) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            return
        }
        guard let data else {
            print("data = nil")
            return
        }
        do {
           let answer = try JSONDecoder().decode(SoonAnswer.self, from: data)
            let list = answer.list
            completion(list)
            print(answer)
        } catch {
            print(error)
        }
    }
    task.resume()
}

func weatherDaily(lat:Double, lon: Double, completion: @escaping (_ daily: [Daily]) -> Void) {
    let urlString =  "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=a4703dd072fe915e8deaafaf6d16b222&lang=ru&units=metric"
    guard let url = URL(string: urlString) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            return
        }
        guard let data else {
            print("data = nil")
            return
        }
        do {
           let answer = try JSONDecoder().decode(DailyAnswer.self, from: data)
            print("🍎 \(answer)")
            guard let daily = answer.daily else {return}
            print(daily)
            completion(daily)
        } catch {
            print(error)
        }
    }
    task.resume()
}
