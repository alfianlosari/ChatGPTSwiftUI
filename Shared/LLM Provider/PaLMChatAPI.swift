//
//  PaLMChatAPI.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/06/23.
//

import Foundation
import GoogleGenerativeAI

class PaLMChatAPI: LLMClient {
    
    var provider: LLMProvider { .palm }
    private let palmClient: GenerativeLanguage
    private var history = [GoogleGenerativeAI.Message]()
    
    init(apiKey: String) {
        self.palmClient = .init(apiKey: apiKey)
    }
    
    func sendMessage(_ text: String) async throws -> String {
        let response = try await palmClient.chat(message: text, history: history)
        if let candidate = response.candidates?.first, let responseText = candidate.content {
            if let historicMessages = response.messages {
                self.history = historicMessages
                self.history.append(candidate)
            }
            return responseText
        } else {
            throw "No response"
        }
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        fatalError("Not supported")
    }
    
    func deleteHistoryList() {
        self.history = []
    }
    
}
