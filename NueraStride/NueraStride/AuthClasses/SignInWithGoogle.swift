//
//  SignInWithGoogle.swift
//  NueraStride
//
//  Created by Nana Bonsu on 3/22/24.
//

import Foundation
import SwiftUI
import GoogleSignIn

class SignInGoogle {
    
    func startSignInWithGoogleFlow() async throws -> SignInGoogleResult {
           await withCheckedContinuation({ [weak self] continuation in
            self?.signInWithGoogleFlow{ result in
            
                switch result {
                case .success(let signInResult):
                    
                    continuation.resume(with: .success(signInResult)) //complete it her
                    
                case .failure(let error):
                    print("Error signing in", error.localizedDescription)
                    
                }
         //
         //
         //                 case .failure(let error):
         //                     print("Error signing in", error)
         //                 }
                     
                      
                    
           
//
//                 continuation.resume(returning: result)
////                 switch result {
////                 case .success(let signInResult):
//
//
//                 case .failure(let error):
//                     print("Error signing in", error)
//                 }
           
            }
        })
        
    }
   func signInWithGoogleFlow(completion: @escaping (Result<SignInGoogleResult, Error>) -> Void) {
       DispatchQueue.main.async {
           guard let topVC = UIApplication.getTopViewController() else {return }
           
           let nonce = self.randomNonceString()
           GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { signInResult, error in
               guard let user = signInResult?.user, let idToken = user.idToken else { //this line will do a conditional binding if the token is there
                   
                   let errorDomain = "Nana-Bonsu.NueraStride"
                   let errCode = GIDSignInError.canceled
                   
                   let errorUserInfo = [
                       NSLocalizedDescriptionKey: "Request was cancelled"
                   ]
                   completion(.failure(NSError(domain: errorDomain, code: errCode.rawValue, userInfo: errorUserInfo))) //error if cant sign in
                   
                   topVC.dismiss(animated: true)
                   return
               }
               completion(.success(.init(idToken: idToken.tokenString, nonce: nonce)))
           }
       }
       
    
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
       
    
}


