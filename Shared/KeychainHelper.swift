//
//  Keychain.swift
//  XCAChatGPT
//
//  Created by Alexey Rogov on 17.03.2023.
//

import Foundation
import Security

class KeychainHelper {
    static let service = "com.chatgpt.app"
    
    static func saveAPITokenToKeychain(token: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "apiToken",
            kSecValueData as String: token.data(using: .utf8)!
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("API token saved to Keychain")
        } else {
            print("Error saving API token to Keychain: \(status)")
        }
    }
    
    static func getAPITokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "apiToken",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess,
            let item = result as? [String: Any],
            let tokenData = item[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: .utf8) {
            print("API token retrieved from Keychain")
            return token
        } else {
            print("Error retrieving API token from Keychain: \(status)")
            return nil
        }
    }
    
    static func updateAPITokenInKeychain(token: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "apiToken",
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: token.data(using: .utf8)!] as CFDictionary)
        
        if status == errSecSuccess {
            print("API token updated in Keychain")
        } else {
            print("Error updating API token in Keychain")
        }
    }
    
    static func deleteAPITokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "apiToken"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Error deleting API token from Keychain")
        }
    }
}

struct ChatGPT {
    static var apiToken: String? {
        get {
            return KeychainHelper.getAPITokenFromKeychain()
        }
        set {
            if let token = newValue {
                if KeychainHelper.getAPITokenFromKeychain() != nil {
                    KeychainHelper.updateAPITokenInKeychain(token: token)
                } else {
                    KeychainHelper.saveAPITokenToKeychain(token: token)
                }
            }
        }
    }
}
