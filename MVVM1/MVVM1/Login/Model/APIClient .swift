//
//  APIClient .swift
//  MVVM1
//
//  Created by user240251 on 6/21/23.
//

import Foundation

enum BackendError: String, Error{
    case invalidEmail = "Comprueba tu Email"
    case invalidPassword = "Comprueba tu Password"
}


final class APIClient {
    func login(withEmail email: String,
               withPassword password: String) async throws -> User {
        // Simular petición HTTP y esperar 2 segundos
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackendLogic(email: email,
                             password: password)
    }
}

func simulateBackendLogic(email: String,
                          password: String) throws -> User {
    guard email == "miemail.123@gmail.com" else {
        print("El user no es")
        throw BackendError.invalidEmail
    }
    guard password == "1234567890" else {
        print("La password no es 1234567890")
        throw BackendError.invalidPassword
    }
    
    print("Success")
    return .init(name: "swiftbeta.blog@gmail.com",
                 token: "1234567890",
                 sessionStart: Date())
}
