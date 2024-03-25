//
//  SignInView.swift
//  NueraStride
//
//  Created by Nana Bonsu on 2/21/24.
//

import SwiftUI

/// Account sign in screen. user can sign in with Google or email/ and password
struct SignInView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    @FocusState private var focus: FocusableField?
    
    @Binding var currentUser:CurrentUser?
    
    private enum FocusableField: Hashable {
        case email
        case password
    }
    
    var body: some View {
        //here have buttons for Sign In With Email, Google, Sign In With Apple
        VStack {
            
            //email field login
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $authModel.userEmail)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password //changes the focus to the  password
                    }
        
            }
            
            .padding([.vertical,.horizontal], 6)
            .background(
                Divider().overlay(Color.black).padding(.horizontal, 10)
                        , alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                  Image(systemName: "lock")
                SecureField("Password", text: $authModel.userPassowrd)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                 //     signInWithEmailPassword()
                    }
                }
            .padding([.vertical,.horizontal], 6)
            .background(
                Divider().overlay(Color.black).padding(.horizontal, 10)
                        , alignment: .bottom)
            .padding(.bottom, 4)
            
            
            Button {
//                Task {
//                    try await authModel.signInWithEmail()
//                    //switch the views.
//                }
            } label: {
               // ProgressView()
            }
            
            
//            Button(action: signInWithEmailPassword) {
//                  if viewModel.authenticationState != .authenticating {
//                    Text("Login")
//                      .padding(.vertical, 8)
//                      .frame(maxWidth: .infinity)
//                  }
//                  else {
//                    ProgressView()
//                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                      .padding(.vertical, 8)
//                      .frame(maxWidth: .infinity)
//                  }
//                }
            
            
            HStack {
                 VStack { Divider() }
                 Text("or")
                 VStack { Divider() }
               }

            oAuthButton(currentUser: $currentUser, buttonText: "Sign Up With Google", imageString: "google", authType: "Google")
                .padding(.horizontal, 20)
            
//            oAuthButton(buttonText: "Sign In With Apple")
//                .padding(.horizontal, 20)
        }
        Text("hello World")
        
       
        
        
    
    }
}

struct oAuthButton: View {
    
    @Environment(\.colorScheme) var appColor
    
    @EnvironmentObject var authModel: AuthViewModel
    
    @Binding var currentUser: CurrentUser?

    var buttonText: String
    var imageString: String
    var authType: String
    
    var body: some View {
        
        Button(action: siginIn) {
            Text(buttonText)
                .foregroundColor(appColor == .dark ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical,8)
                .background(alignment: .leading) {
                    Image(imageString)
                        .resizable()
                        .frame(width: 40, alignment: .center)
                }
        }
        .buttonStyle(.bordered)
    }
    
    
    func siginIn() {
        switch authType {
        case "Google":
            
            Task {
                do {
                    let currentUser = try await authModel.signInWithGoogle()
                    self.currentUser = currentUser
                } catch {
                    print("Error:\(error.localizedDescription)")
                }
            }
        case "Apple":
            print("Deez")
        default:
            break
        }
    }
    
}


//from firebase video// (building the buttons from the firebase video!)

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var currentUser: CurrentUser? = CurrentUser(uid: "", email: nil)
        
        SignInView(currentUser: $currentUser)
            .environmentObject(AuthViewModel())
    }
}
