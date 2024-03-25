//
//  ContentView.swift
//  NueraStride
//
//  Created by Nana Bonsu on 2/20/24.
//

import SwiftUI

/// Screen for user to see app introduction and sign up/sign in
struct WelcomeView: View {
    
    @Binding var currentUser:CurrentUser?
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Spacer()
            
            Button("Hello") {}
                .padding([.bottom],20)
        }
        
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Sign Out") {
                    Task {
                        try await AuthManager.shared.signOut()
                        withAnimation(.easeIn) {
                            currentUser = nil
                        }
                    }
                }
               
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var currentUser: CurrentUser? = CurrentUser(uid: "", email: nil)
        
        WelcomeView(currentUser: $currentUser)
    }
}
