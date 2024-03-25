//
//  SignInWithApple.swift
//  NueraStride
//
//  Created by Nana Bonsu on 3/22/24.
//

import Foundation
import AuthenticationServices
import CryptoKit


struct SIgnInAppleResult {
    let idToken: String
    let nonce: String
}

class SignInApple: NSObject {
    
    fileprivate var currentNonce: String?
    private var completionHandler: ((Result<SIgnInAppleResult, Error>) -> Void)? //define a completion handler, that will be used to notify of process finish
    

    
    ///  begins Sign In With Apple and initiates the screens that enables a user to sign in
    /// - Parameter completion: the handler which returns a result or an error
    func startSignInWithAppleFlow(completion: @escaping (Result<SIgnInAppleResult, Error>) -> Void) {
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(NSError()))
            return
        }
        
        let nonce = randomNonceString()
         currentNonce = nonce
         completionHandler = completion
         let appleIDProvider = ASAuthorizationAppleIDProvider()
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email]
         request.nonce = sha256(nonce)

         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
    }
}

extension SignInApple: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
         guard let nonce = currentNonce, let completion = completionHandler else {
           fatalError("Invalid state: A login callback was received, but no login request was sent.")
         }
         guard let appleIDToken = appleIDCredential.identityToken else {
           print("Unable to fetch identity token")
           return
         }
         guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
           print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
           return
         }
         // Initialize a Firebase credential, including the user's full name.
         
         // Sign in with Firebase.
      
           let appleResult = SIgnInAppleResult(idToken: idTokenString, nonce: nonce)
           completion(.success(appleResult))
       }
     }

     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       // Handle error.
       print("Sign in with Apple errored: \(error)")
     }

    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
         var randomBytes = [UInt8](repeating: 0, count: length)
         let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
         if errorCode != errSecSuccess {
           fatalError(
             "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
           )
         }

         let charset: [Character] =
           Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

         let nonce = randomBytes.map { byte in
           // Pick a random character from the set, wrapping around if needed.
           charset[Int(byte) % charset.count]
         }

         return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        
        
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
