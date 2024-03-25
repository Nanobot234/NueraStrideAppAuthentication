//
//  AuthManager.swift
//  NueraStride
//
//  Created by Nana Bonsu on 3/18/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import Supabase

/// the current logged in user of the application
struct CurrentUser {
    let uid: String
    let email: String?
}


class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    let supabaseClient = SupabaseClient(supabaseURL: APIKeys.projectURL!, supabaseKey: APIKeys.apiKey)
    
    
    func getCurrentSession() async throws -> CurrentUser {
        let currentSession = try await supabaseClient.auth.session
        return CurrentUser(uid: currentSession.user.id.uuidString, email: currentSession.user.email)
    }
    
    /// Creates a session when a user signs in with Google and returns a CurentUser object.
    /// - Parameters:
    ///   - idToken: the iDToken for the user
    ///   - nonce: <#nonce description#>
    /// - Returns: A `CurrentUser` object
    func signInWithGoogle(idToken: String, nonce: String) async throws -> CurrentUser {
        let currentSession = try await supabaseClient.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken, nonce: nonce))
        
        return CurrentUser(uid: currentSession.user.id.uuidString , email: currentSession.user.email)
    }
    
    func signInWithApple() {
        
    }
    
    func signOut() async throws {
        try await supabaseClient.auth.signOut()
    }
    
    

}

///  Defiens the token of a sucessful sign in with Google
struct SignInGoogleResult {
    let idToken: String
    let nonce: String //a unique number used for authentication?
}

