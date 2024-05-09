//
//  PlayerData.swift
//  Avia Blitz
//
//  Created by Anton on 7/5/24.
//

import Foundation

class PlayerData: ObservableObject {
    
    @Published var points = UserDefaults.standard.integer(forKey: "points")
    
    @Published var plane = UserDefaults.standard.string(forKey: "plane")
    @Published var biome = UserDefaults.standard.string(forKey: "biome")
    
    func setPoints(points: Int) {
        self.points = points
        UserDefaults.standard.set(self.points, forKey: "points")
    }
    
    func setPlane(plane: String) {
        self.plane = plane
        UserDefaults.standard.set(self.plane, forKey: "plane")
    }
    
    func setBiome(biome: String) {
        self.biome = biome
        UserDefaults.standard.set(self.biome, forKey: "biome")
    }
    
}
