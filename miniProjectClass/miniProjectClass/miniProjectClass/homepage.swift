//
//  homepage.swift
//  miniProjectClass
//
//  Created by Tekup-mac-6 on 30/4/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct homepage: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var age = ""
    @State private var city = ""
    var body: some View {
        VStack {
            
            Image("rm")    .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                    TextField("Age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                    TextField("City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Add Customer") {
                       addCustomer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding()
                }
                .padding()
                .navigationBarTitle("Add Customer")
            }
    
    func addCustomer() {
            // Create a dictionary with customer details
            let customerData = [
                "firstName": firstName,
                "lastName": lastName,
                "phoneNumber": phoneNumber,
                "age": age,
                "city": city
            ]
            
            // Reference to the Firebase database
            let db = Firestore.firestore()
            
            // Add a new document with a generated ID
            db.collection("customers").addDocument(data: customerData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    // Optionally, show an alert or navigate to another view after successful addition
                }
            }
        }
    
}

#Preview {
    homepage()
}
