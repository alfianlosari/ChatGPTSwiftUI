//
//  LLMConfig.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/06/23.
//

import Foundation

struct LLMConfig: Identifiable, Hashable {
    
    var id: String { apiKey }
    
    let apiKey: String
    let type: ConfigType
    
    enum ConfigType: Hashable {
        case chatGPT(ChatGPTModel)
        case palm
    }
    
    func createClient() -> LLMClient {
        switch self.type {
        case .chatGPT(let model):
            return ChatGPTAPI(apiKey: apiKey, model: model.rawValue)
        case .palm:
            return PaLMChatAPI(apiKey: apiKey)
        }
    }
    
}
