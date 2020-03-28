//
//  MeatTemperature.swift
//  NoPonto WatchKit Extension
//
//  Created by Danilo S Nascimento on 27/03/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation

enum MeatTemperature : Int {
    case rare = 0, mediumRare, medium, wellDone
    
    var stringValue: String {
        let temperatures = ["Cru", "Mal passado", "Ao Ponto", "Bem Passado"]
        return temperatures[self.rawValue]
    }
    
    var timeModifier: Double {
        let modifiers = [0.5, 0.75, 1, 1.5]
        return modifiers[self.rawValue]
    }
    
    func cookTimeForKg(_ kg: Double) -> TimeInterval {
        let baseTime: TimeInterval = 13 * 60
        let baseWeight = 0.5
        let weightModifier = kg/baseWeight
        return baseTime * weightModifier * timeModifier
    }
    
    
    
}
