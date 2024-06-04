//
//  products.swift
//  miniProjectClass
//
//  Created by Tekup-mac-6 on 13/5/2024.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct products: View {
    @State private var products: [[String: String]] = [] // Define an array to hold products
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(products, id: \.self) { product in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(product["name"] ?? "")")
                                .font(.headline)
                            Text("Price: \(product["price"] ?? "")")
                            Text("Description: \(product["description"] ?? "")")
                        }
                        .padding(10) // Add padding to the entire product item
                        
                        Button(action: {
                            self.deleteProduct(product)
                        }) {
                            Text("Delete")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the default button styling
                    }
                }
                .navigationBarTitle("Products")
                .onAppear {
                    self.fetchProducts()
                }
                
                // Button to navigate to addproduct view
                NavigationLink(destination: AddProductView(addProduct: self.addProduct)) {
                    Text("Add New Product")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
    
    func fetchProducts() {
        let db = Firestore.firestore()
        
        db.collection("products").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.products = documents.compactMap { document in
                        guard let data = document.data() as? [String: Any] else { return nil }
                        
                        // Convert values to String
                        let name = data["name"] as? String ?? ""
                        let price = data["price"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        
                        return [
                            "id": document.documentID, // Add document ID for updating/deleting
                            "name": name,
                            "price": price,
                            "description": description
                        ]
                    }
                }
            }
        }
    }
    
    func addProduct(productData: [String: String]) {
        let db = Firestore.firestore()
        
        db.collection("products").addDocument(data: productData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                self.fetchProducts() // Refresh the list after adding a product
            }
        }
    }
    
    func deleteProduct(_ product: [String: String]) {
        guard let productId = product["id"] else { return }
        
        let db = Firestore.firestore()
        
        db.collection("products").document(productId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
                self.fetchProducts() // Refresh the list after deleting a product
            }
        }
    }
}

struct AddProductView: View {
    let addProduct: ([String: String]) -> Void
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
            TextField("Price", text: $price)
                .padding()
            TextField("Description", text: $description)
                .padding()
            
            Button("Add Product") {
                let productData = [
                    "name": name,
                    "price": price,
                    "description": description
                ]
                self.addProduct(productData)
            }
            .padding()
        }
        .navigationBarTitle("Add Product")
    }
}

#Preview {
    products()
}
