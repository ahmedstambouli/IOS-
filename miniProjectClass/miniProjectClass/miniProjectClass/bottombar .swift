//
//  bottombar .swift
//  miniProjectClass
//
//  Created by Tekup-mac-6 on 7/5/2024.
//

import SwiftUI

struct bottombar_: View {
    var body: some View {
        TabView{
          
            
            listcustomer().tabItem ()
            {
            Image(systemName: "person.fill")
            Text("list Customer")
                
            }
            products().tabItem ()
            {
            Image(systemName: "suitcase.cart.fill")
            Text("list product")
                
            }
            
            
        }
    }
          
}

#Preview {
    bottombar_()
}
