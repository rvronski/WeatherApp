//
//  String.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 02.02.2023.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
        
    }
    
}
