//
//  NueraStrideApp.swift
//  NueraStride
//
//  Created by Nana Bonsu on 2/20/24.
//

import SwiftUI
import GoogleSignIn

@main
struct NueraStrideApp: App {
    
    @State var navPath = NavigationPath()
    @StateObject var authModel = AuthViewModel()
    //
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navPath) {
                ContentView()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }

            }
            .environmentObject(authModel)
            
        }
    }
}
