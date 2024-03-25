//
//  ContentView.swift
//  NueraStride
//
//  Created by Nana Bonsu on 3/18/24.
//

import SwiftUI
import Supabase

/// Acts as a view container  that displays a view based on the logged in user state.
struct ContentView: View {
    @State  var currentUser: CurrentUser? = nil //the current user in the app
    
    var body: some View {
        ZStack {
            if let currentUser = currentUser {
                WelcomeView(currentUser: $currentUser)
            } else {
                SignInView(currentUser: $currentUser)
            }
        }
        .onAppear {
            Task {
                self.currentUser = try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
