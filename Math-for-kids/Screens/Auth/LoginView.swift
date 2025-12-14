//
//  LoginView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        AuthBackground {
            AuthCard(height: 472) {
                VStack(alignment: .center, spacing: 20) {
                    Text("Sign In")
                        .font(.LilitaOne(size: .xlg))
                        .foregroundStyle(.textPrimary)
                    
                    AvatarGroup()
                    
                    VStack(spacing: 20) {
                        MathTextField(
                            label: "Email",
                            text: $email,
                            placeholder: "Enter your email"
                        )
                        
                        MathTextField(
                            label: "Password",
                            text: $password,
                            isSecure: true,
                            placeholder: "Enter your password"
                        )
                    }
                    
                    Button {
                        
                    } label: {
                        Text("LOGIN")
                    }
                    .buttonStyle(MathButtonBrandStyle(style: .success, fullWidth: true))
                    
                    HStack(spacing: 2){
                        Text("Don't have an account?")
                            .font(.Rubik(size: .md))
                            .fontWeight(.semibold)
                            .foregroundStyle(.textInactive)
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .font(.Rubik(size: .md))
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandContent)
                        }
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("back-path-arrow")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

#Preview {
    LoginView()
}

