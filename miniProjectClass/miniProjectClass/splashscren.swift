//
//  splashscren.swift
//  miniProjectClass
//
//  Created by Tekup-mac-6 on 30/4/2024.
//

import SwiftUI
import Lottie

struct splashscren: View {
    
    @State private var islogged = false
    var body: some View {
        VStack {
            LottieView(animation: .named("Animation - 1714466326671")).looping()
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                islogged = true
            }    
        }
        .fullScreenCover(isPresented: $islogged){
            ContentView()
        }
        
    }
}

#Preview {
    splashscren()
}
