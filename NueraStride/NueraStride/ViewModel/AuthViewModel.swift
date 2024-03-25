//
//  AuthViewModel.swift
//  NueraStride
//
//  Created by Nana Bonsu on 2/20/24.
//

import Foundation
import Supabase
import GoogleSignIn



//
//enum AuthAction: String, CaseIterable {
//     case signUpWithEmail = "Sign Up"
//     case signInWithEmail = "Sign In"
//     //
//}


/// manages interaxtions between UI and Supabase database.
final class AuthViewModel:ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var userEmail = ""
    @Published var userPassowrd = ""
  //  @Published var authAction: AuthAction = .signUp
    //supabase client intialization here
     
    
    //TODO: Moving the thinggs below to the auth Manager
    let supabaseClient = SupabaseClient(supabaseURL: APIKeys.projectURL!, supabaseKey: APIKeys.apiKey)
    
    
//    /// function to signUp user with email
//    func signUpWithEmail() async throws {
//        let signUpResponse = try await supabaseClient.auth.signUp(email: userEmail, password: userPassowrd)
//      //need to check fo  errors, not checked well, look back at docs first
//        Task {
//
//         //   SignInView()
//        }
//
//    }
//
//    func signInWithEmail() async throws {
//       let signUpResponse = try await supabaseClient.auth.signIn(email: userEmail, password: userPassowrd)
//    }
    
    /// 
   
    /// check for user authentication Status
//    func isUserAuthenticated() async {
//        do {
//            _ = try await supabaseClient.auth.session.user
//            isAuthenticated = true
//        } catch {
//            isAuthenticated = false
//        }
//    }
    

    
    ///  creates a `CurrentUser` object!!
    /// - Returns: <#description#>
    func signInWithGoogle() async throws -> CurrentUser  {
      
       let signInWithGoogle = SignInGoogle()
        let googleResult =  try await signInWithGoogle.startSignInWithGoogleFlow()
        return try await AuthManager.shared.signInWithGoogle(idToken: googleResult.idToken, nonce: googleResult.nonce)
        
    }
    
   
    
//    func authorize() async throws {
//        //cant switch on the type need to switch on value of the type!!
//        switch authAction {
//        case .signUp:
//            try await signUp()
//        case .signIn:
//            try await signIn()
//        }
//    }
    
}

// MARK: UIApplication extensions
extension UIApplication {
    
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        // Ensure execution on the main thread
        guard Thread.isMainThread else {
            // Call the function again on the main thread
            var topViewController: UIViewController?
            DispatchQueue.main.sync {
                topViewController = getTopViewController(base: base)
            }
            return topViewController
        }
        
        // Your existing code to get the top view controller
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }


}




