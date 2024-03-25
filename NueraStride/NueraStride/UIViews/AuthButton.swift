//
//  AuthButtons.swift
//  NueraStride
//
//  Created by Nana Bonsu on 2/21/24.
//

import SwiftUI

struct AuthButton: View {
    
    //label?
    var buttonTitle:String?
    var buttonImage:String?
    
    var body: some View {
        
        Button {
            
        } label: {
            Label("Sign In", image: "AppIcon")
                .frame(maxWidth: .infinity,maxHeight: 60)
                .foregroundColor(Color.purple)
        }
        .background(Color.black)
        .cornerRadius(25)
        .padding(.horizontal,20)
        
        //TODO: make the background light purple!
        

    }
}

struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(buttonTitle: nil,buttonImage: nil)
    }
}
