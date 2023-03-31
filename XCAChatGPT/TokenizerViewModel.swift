//
//  TokenizerViewModel.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 28/03/23.
//

import Combine
import Foundation
import SwiftUI
import GPTEncoder

struct TokenOutput {
    let text: String
    let stringTokens: [String]
    let tokens: [Int]
}

enum OutputType: Identifiable {
    case text, tokenIds
    var id: Self { self }
}

class TokenizerViewModel: ObservableObject, @unchecked Sendable {
    
    let tokenizer = GPTEncoder()
    
    @Published var inputText = ""
    @Published var output: TokenOutput?
    @Published var isTokenizing = false
    @Published var error: String?
    @Published var isShowingError = false
    @Published var outputType = OutputType.text
    
    var cancellables = Set<AnyCancellable>()
    var task: Task<(), Never>?
    
    init() {
        startObserve()
    }
    
    func startObserve() {
        $inputText
            .filter { !$0.isEmpty }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.task?.cancel()
                if self.inputText.isEmpty {
                    return
                }
                self.task = Task { await self.tokenize(value: value) }
            }.store(in: &cancellables)
        
        
        $inputText
            .filter { $0.isEmpty }
            .sink { [weak self] _ in
                withAnimation { self?.output = nil }
            }.store(in: &cancellables)
    }
    
    func tokenize(value: String) async {
        if Task.isCancelled { return }
        
        Task { @MainActor [weak self] in
            withAnimation {
                self?.isTokenizing = true
            }
        }
        
        let tokens = self.tokenizer.encode(text: value)
        let stringTokens = tokens.map { tokenizer.decode(tokens: [$0]) }
        
        Task { @MainActor [weak self] in
            if Task.isCancelled { return }
            withAnimation {
                self?.output = .init(text: value, stringTokens: stringTokens, tokens: tokens)
                self?.isTokenizing = false
            }
        }
    }
    
}
