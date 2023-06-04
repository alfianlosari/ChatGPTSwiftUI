//
//  ChatGPTAPIModels.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/03/23.
//

import Foundation

enum ChatGPTModel: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case gpt3Turbo = "gpt-3.5-turbo"
    case gpt4 = "gpt-4"
    
    var text: String {
        switch self {
        case .gpt3Turbo:
            return "GPT-3.5"
        case .gpt4:
            return "GPT-4"
        }
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

extension Array where Element == Message {
    
    var contentCount: Int { reduce(0, { $0 + $1.content.count })}
}

struct Request: Codable {
    let model: String
    let temperature: Double
    let messages: [Message]
    let stream: Bool
}

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable {
    let message: Message
    let finishReason: String?
}

struct StreamChoice: Decodable {
    let finishReason: String?
    let delta: StreamMessage
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}

