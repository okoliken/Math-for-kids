//
//  SignUpView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        AuthBackground {
            AuthCard(height: 472) {
                VStack(alignment: .center, spacing: 20) {
                    Text("Create Account!")
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
                    
                    NavigationLink {
                        OnboardingFlowView()
                            .environment(authManager)
                    } label: {
                        Text("CREATE ACCOUNT!")
                    }
                    .buttonStyle(MathButtonBrandStyle(style: .success, fullWidth: true))
                    
                    HStack(spacing: 2){
                        Text("Already have an account?")
                            .font(.Rubik(size: .md))
                            .fontWeight(.semibold)
                            .foregroundStyle(.textInactive)
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Sign In")
                                .font(.Rubik(size: .md))
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandContent)
                        }
                    }
                }
            }
            .frame(maxWidth: 380)
//            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back-path-arrow")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }

               
            }
        }
    }
}

#Preview {
    SignUpView()
}

