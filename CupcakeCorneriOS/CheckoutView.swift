//
//  CheckoutView.swift
//  CupcakeCorneriOS
//
//  Created by Alison Gorman on 10/28/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order : OrderC
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = ""
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
            let decodedOrder = try JSONDecoder().decode(OrderS.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(OrderS.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            alertTitle = "Thanks!"
        } catch {
            print("Checkout failed.")
            confirmationMessage = "There was a problem sending your order. Please check your internet connection"
            showingConfirmation = true
            alertTitle = "Oops!"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: OrderC())
    }
}
