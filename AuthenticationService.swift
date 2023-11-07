import Foundation
import KeychainAccess

class AuthenticationService {

    static let shared = AuthenticationService()
    private let keychain = Keychain(service: "com.yourappname.keychain")

    private init() {}

    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        // Assuming `signin` is the endpoint for the API that handles the sign-in process
        NetworkManager.shared.performRequestWithRetry(endpoint: "signin", method: "POST", parameters: parameters) { (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authResponse):
                do {
                    try self.keychain.set(authResponse.token, key: "authToken")
                    completion(.success(authResponse.user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // The signUp method would be similar to the signIn method

    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try keychain.remove("authToken")
            completion(true)
        } catch {
            completion(false)
        }
    }

    func isUserLoggedIn() -> Bool {
        return keychain["authToken"] != nil
    }

    // ... Other methods remain the same
}

// Define the structures used for decoding the API responses

struct AuthResponse: Decodable {
    let user: User
    let token: String
}

struct User: Decodable {
    let id: String
    let email: String
    // Add other user properties here
}
