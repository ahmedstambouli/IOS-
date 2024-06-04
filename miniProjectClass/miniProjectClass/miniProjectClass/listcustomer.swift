/*import SwiftUI
import Firebase
import FirebaseFirestore

struct listcustomer: View {
    @State private var customers: [[String: String]] = [] // Define an array to hold customers
    
    var body: some View {
        NavigationView {
            VStack {
                List(customers, id: \.self) { customer in
                    VStack(alignment: .leading) {
                        Text("Name: \(customer["firstName"] ?? "") \(customer["lastName"] ?? "")")
                        Text("Phone Number: \(customer["phoneNumber"] ?? "")")
                        Text("Age: \(customer["age"] ?? "")")
                        Text("City: \(customer["city"] ?? "")")
                    }
                }
                .navigationBarTitle("Customers")
                .onAppear {
                    self.fetchCustomers()
                }
                
                // Button to navigate back to homepage
                NavigationLink(destination: homepage()) {
                    Text("Add new customer")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
    
    func fetchCustomers() {
        let db = Firestore.firestore()
        
        db.collection("customers").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.customers = documents.compactMap { document in
                        guard let data = document.data() as? [String: Any] else { return nil }
                        
                        // Convert values to String
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let age = data["age"] as? String ?? ""
                        let city = data["city"] as? String ?? ""
                        
                        return [
                            "firstName": firstName,
                            "lastName": lastName,
                            "phoneNumber": phoneNumber,
                            "age": age,
                            "city": city
                        ]
                    }
                }
            }
        }
    }
}

struct listcustomer_Previews: PreviewProvider {
    static var previews: some View {
        listcustomer()
    }
}*/

import SwiftUI
import Firebase
import FirebaseFirestore

struct listcustomer: View {
    @State private var customers: [[String: String]] = [] // Define an array to hold customers
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(customers, id: \.self) { customer in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(customer["firstName"] ?? "") \(customer["lastName"] ?? "")")
                                .font(.headline)
                            Text("Phone Number: \(customer["phoneNumber"] ?? "")")
                            Text("Age: \(customer["age"] ?? "")")
                            Text("City: \(customer["city"] ?? "")")
                        }
                        .padding(10) // Add padding to the entire customer item
                        
                        Button(action: {
                            self.deleteCustomer(customer)
                        }) {
                            Text("Delete")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the default button styling
                    }
                }                .navigationBarTitle("Customers")
                .onAppear {
                    self.fetchCustomers()
                }
                
                // Button to navigate to addcustomer view
                NavigationLink(destination: AddCustomerView(addCustomer: self.addCustomer)) {
                    Text("Add New Customer")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
    
    func fetchCustomers() {
        let db = Firestore.firestore()
        
        db.collection("customers").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.customers = documents.compactMap { document in
                        guard let data = document.data() as? [String: Any] else { return nil }
                        
                        // Convert values to String
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let age = data["age"] as? String ?? ""
                        let city = data["city"] as? String ?? ""
                        
                        return [
                            "id": document.documentID, // Add document ID for updating/deleting
                            "firstName": firstName,
                            "lastName": lastName,
                            "phoneNumber": phoneNumber,
                            "age": age,
                            "city": city
                        ]
                    }
                }
            }
        }
    }
    
    func addCustomer(customerData: [String: String]) {
        let db = Firestore.firestore()
        
        db.collection("customers").addDocument(data: customerData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                self.fetchCustomers() // Refresh the list after adding a customer
            }
        }
    }
    
    func deleteCustomer(_ customer: [String: String]) {
        guard let customerId = customer["id"] else { return }
        
        let db = Firestore.firestore()
        
        db.collection("customers").document(customerId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
                self.fetchCustomers() // Refresh the list after deleting a customer
            }
        }
    }
}

struct AddCustomerView: View {
    let addCustomer: ([String: String]) -> Void
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var age = ""
    @State private var city = ""
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .padding()
            TextField("Last Name", text: $lastName)
                .padding()
            TextField("Phone Number", text: $phoneNumber)
                .padding()
            TextField("Age", text: $age)
                .padding()
            TextField("City", text: $city)
                .padding()
            
            Button("Add Customer") {
                let customerData = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "phoneNumber": phoneNumber,
                    "age": age,
                    "city": city
                ]
                self.addCustomer(customerData)
            }
            .padding()
        }
        .navigationBarTitle("Add Customer")
    }
}

