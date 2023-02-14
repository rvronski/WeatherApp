//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 14.02.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = .init()
    
lazy var persistentContainer: NSPersistentContainer = {
    
    
    let container = NSPersistentContainer(name: "WeatherApp")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
}()


func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            print(error)
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

    func createNowWeather(weather: WheatherAnswer , completion: @escaping (NowWeather?) -> Void ) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let dt = weather.dt ?? 0
            if self.chekWeather(dt: dt, context: backgroundContext) != nil {
                completion(nil)
            } else {
                let nowWeather = NowWeather(context: backgroundContext)
                let clouds = weather.clouds?.all ?? 0
                let dt = weather.dt ?? 0
                let humidity = weather.main?.humidity ?? 0
                let name = weather.name ?? ""
                let sunrise = weather.sys?.sunrise ?? 0
                let sunset = weather.sys?.sunset ?? 0
                let temp = weather.main?.temp ?? 0
                let tempMax = weather.main?.tempMax ?? 0
                let tempMin = weather.main?.tempMin ?? 0
                let timezone = weather.timezone ?? 0
                let windSpeed = weather.wind?.speed ?? 0
                nowWeather.timezone = Double(timezone)
                nowWeather.clouds = Double(clouds)
                nowWeather.dt = Double(dt)
                nowWeather.humidity = Double(humidity)
                nowWeather.name = name
                nowWeather.sunrise = Double(sunrise)
                nowWeather.sunset = Double(sunset)
                nowWeather.temp = Double(temp)
                nowWeather.tempMax = Double(tempMax)
                nowWeather.tempMin = Double(tempMin)
                nowWeather.windSpeed = Double(windSpeed)
                nowWeather.date = Date()
                do {
                    try backgroundContext.save()
                } catch {
                    print(error)
                    completion(nil)
                }
                completion(nowWeather)
            }
        }
    }
    func chekWeather(dt: Int, context: NSManagedObjectContext) -> NowWeather? {
        let fetchRequest = NowWeather.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dt == %@", dt)
       return (try? context.fetch(fetchRequest))?.first
    }
    
    func deleteNowWeather(nowWeather: NowWeather) {
        persistentContainer.viewContext.delete(nowWeather)
        saveContext()
    }
}

