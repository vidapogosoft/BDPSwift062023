//
//  LoginViewModel.swift
//  MVVM1
//
//  Created by user240251 on 6/21/23.
//

import Foundation
import Combine

class LoginViewModel {
    
    
    @Published var email = ""
        @Published var password = ""
    @Published var isEnabled = false
    @Published var showLoading = false
    @Published var errorMessage = ""
    @Published var userModel: User?
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        
        formValidation()
    }

    func formValidation() {
        $email.sink { value in
            print("Email: \(value)")
        }.store(in: &cancellables)
        
        $password.sink { value in
            print("Password: \(value)")
        }.store(in: &cancellables)
        
        /*
        $email
                .filter { $0.count > 5 }
                .receive(on: DispatchQueue.main)
                .sink { value in
                    self.isEnabled = true
                }.store(in: &cancellables)
         */
        
        Publishers.CombineLatest($email, $password)
               .filter { email, password in
                   return email.count >= 5 && password.count >= 5
               }
               .sink { value in
                   self.isEnabled = true
           }.store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(withEmail email: String,
               withPassword password: String) {
        showLoading = true
        errorMessage = ""
        Task {
            do {
                userModel = try await apiClient.login(withEmail: email,
                                                  withPassword: password)
            } catch let error as BackendError {
                print(error.localizedDescription)
                errorMessage = error.rawValue
                
            }
            showLoading = false
        }
    }
}
