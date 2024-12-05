//
//  AuthService.swift
//  atehere-manager-swiftui
//
//  Created by Berke Bozacı on 3.11.2024.
//

import Foundation
import Security
import FirebaseAuth

class AuthService {
    static let shared = AuthService()

    private init() {}


    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let firebaseUser = authResult?.user else {
                completion(.failure(AuthErrorCode.userNotFound))
                return
            }
            self.storeUserCredentials(user: firebaseUser)
            completion(.success(firebaseUser))
        }
    }

    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }


    private func storeUserCredentials(user: FirebaseAuth.User) {
        //print("Store user credentials is called")
        user.getIDToken { token, error in
            if let token = token {
                print(token)
                self.storeValue(token, key: "idToken")
            }
        }
    }

    private func storeValue(_ value: String, key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("Error storing \(key) in Keychain: \(status)")
        }
    }

    func getIdToken(completion: @escaping (String?) -> Void) {
        //print("Get id token is called")
        if let token = getValue(forKey: "idToken"), isTokenValid(token) {
            //print(token)
            completion(token)
        } else {
            if let user = Auth.auth().currentUser {
                user.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
                    if let idToken = idToken {
                        self?.storeValue(idToken, key: "idToken")
                        completion(idToken)
                    } else {
                        print("Error retrieving idToken: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }

    private func getValue(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess {
            if let data = item as? Data, let value = String(data: data, encoding: .utf8) {
                return value
            }
        } else {
            print("Error retrieving \(key) from Keychain: \(status)")
        }

        return nil
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            deleteValue(forKey: "idToken")
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    private func deleteValue(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting \(key) from Keychain: \(status)")
        }
    }
    
    private func isTokenValid(_ token: String) -> Bool {
        //print("Is token Valid function is called")
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return false }
        
        let payloadSegment = segments[1]
        let paddedPayload = self.padBase64(String(payloadSegment))
        guard let payloadData = Data(base64Encoded: paddedPayload) else { return false }
        
        guard let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return false
        }
        
        guard let exp = payload["exp"] as? TimeInterval else { return false }
        
        let currentTime = Date().timeIntervalSince1970
        //print(exp)
        //print(currentTime)
        return exp > currentTime
    }
        
    private func padBase64(_ base64String: String) -> String {
        let remainder = base64String.count % 4
        if remainder > 0 {
            return base64String + String(repeating: "=", count: 4 - remainder)
        }
        return base64String
    }
}
