import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    @State private var selectedColorIndex = false
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = false
    @State private var isPasswordValid = false

    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {

        NavigationView(content: {
            ScrollView{
                VStack {
                    Picker(selection: $selectedColorIndex, label: Text("Picker")) {
                        Text("LOGIN").tag(true)
                        Text("CREATE ACCOUNT").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle()) // <1>
                    
                }
                if selectedColorIndex {
                    VStack{
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                            .onChange(of: email) { newValue in
                                isEmailValid = isValidEmail(newValue)
                            }
                            .foregroundColor(isEmailValid ? .black : .red) // Change text color based on validation
                            
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                            .onChange(of: password) { newValue in
                                isPasswordValid = isValidPassword(newValue)
                            }
                            .foregroundColor(isPasswordValid ? .black : .red) // Change text color based on validation
                        
                        Button("LOGIN") {
                            login()
                        }
                        .padding()
                        .frame(width: 350)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(!isEmailValid || !isPasswordValid) // Disable button if either email or password is invalid
                        
                    }
                } else {
                    VStack{
                        Image("user")
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                            .onChange(of: email) { newValue in
                                isEmailValid = isValidEmail(newValue)
                            }
                            .foregroundColor(isEmailValid ? .black : .red) // Change text color based on validation
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                            .onChange(of: password) { newValue in
                                isPasswordValid = isValidPassword(newValue)
                            }
                            .foregroundColor(isPasswordValid ? .black : .red) // Change text color based on validation
                        
                        Button("CREATE ACCOUNT") {
                            register()
                        }
                        .padding()
                        .frame(width: 350)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(!isEmailValid || !isPasswordValid) // Disable button if either email or password is invalid
                    }
                }
            }
            .navigationTitle(selectedColorIndex ? "LOGIN" :"CREATE ACCOUNT")
        })
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else {
                print("User created successfully")
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: bottombar_()) // Assuming BottomBar is your destination view
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    // Function to validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // Function to validate password format (minimum 8 characters)
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
