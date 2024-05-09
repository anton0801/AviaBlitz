//
//  ShopData.swift
//  Avia Blitz
//
//  Created by Anton on 7/5/24.
//

import Foundation

class ShopData: ObservableObject {
    
    var playerData: PlayerData
    
    var planes = [
        ShopItem(name: "plane_2", price: 10000),
        ShopItem(name: "plane_3", price: 15000),
        ShopItem(name: "plane_4", price: 20000)
    ]
    
    var biomes = [
        ShopItem(name: "biome_2", price: 25000),
        ShopItem(name: "biome_3", price: 30000),
        ShopItem(name: "biome_4", price: 35000)
    ]
    
    @Published var buyedShopItems = [String]()
    
    init(playerData: PlayerData) {
        self.playerData = playerData
        initBuyedItems()
    }
    
    private func initBuyedItems() {
        var buyedShopItems = UserDefaults.standard.string(forKey: "buyedShopItems")?.components(separatedBy: ",") ?? []
        for shopItem in buyedShopItems {
            buyedShopItems.append(shopItem)
        }
    }
    
    func tryToBuyShopItem(_ shopItem: ShopItem) -> Bool {
        if playerData.points >= shopItem.price {
            playerData.points -= shopItem.price
            buyedShopItems.append(shopItem.name)
            UserDefaults.standard.set(buyedShopItems.joined(separator: ","), forKey: "buyedShopItems")
            if shopItem.name.contains("biome") {
                playerData.setBiome(biome: shopItem.name)
            } else {
                playerData.setPlane(plane: shopItem.name)
            }
            return true
        }
        return false
    }
    
}
