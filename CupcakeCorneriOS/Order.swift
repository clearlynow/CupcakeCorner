//
//  Order.swift
//  CupcakeCorneriOS
//
//  Created by Alison Gorman on 10/28/22.
//

import Foundation

class OrderC: ObservableObject {
    @Published var order : OrderS
    
    init() {
        order = OrderS()
    }
}

struct OrderS: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var extraFrosting = false
    var addSprinkles = false

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
}


