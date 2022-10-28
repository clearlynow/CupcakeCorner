//
//  AddressView.swift
//  CupcakeCorneriOS
//
//  Created by Alison Gorman on 10/28/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order : OrderC
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.order.name)
                TextField("Street Address", text: $order.order.streetAddress)
                TextField("City", text: $order.order.city)
                TextField("Zip", text: $order.order.zip)
            }

            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: OrderC())
    }
}
