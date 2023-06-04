//
//  LLMClient.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/06/23.
//

import Foundation

protocol LLMClient {
    
    var provider: LLMProvider { get }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error>
    func sendMessage(_ text: String) async throws -> String
    func deleteHistoryList()
    
}
