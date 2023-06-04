//
//  LLMProvider.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/06/23.
//

import Foundation

enum LLMProvider: Identifiable, CaseIterable {
    
    case chatGPT
    case palm
    
    var id: Self { self }
    
    var text: String {
        switch self {
        case .chatGPT:
            return "OpenAI ChatGPT"
        case .palm:
            return "Google PaLM"
        }
    }
    
    var footerInfo: String {
        switch self {
        case .chatGPT:
            return """
ChatGPT is an artificial intelligence (AI) chatbot developed by OpenAI and released in November 2022. The name "ChatGPT" combines "Chat", referring to its chatbot functionality, and "GPT", which stands for Generative Pre-trained Transformer, a type of large language model (LLM). ChatGPT is built upon OpenAI's foundational GPT models, specifically GPT-3.5 and GPT-4, and has been fine-tuned (an approach to transfer learning) for conversational applications using a combination of supervised and reinforcement learning techniques.
"""
        case .palm:
            return """
PaLM (Pathways Language Model) is a 540 billion parameter transformer-based large language model developed by Google AI.Researchers also trained smaller versions of PaLM, 8 and 62 billion parameter models, to test the effects of model scale.
            
PaLM is capable of a wide range of tasks, including commonsense reasoning, arithmetic reasoning, joke explanation, code generation, and translation. When combined with chain-of-thought prompting, PaLM achieved significantly better performance on datasets requiring reasoning of multiple steps, such as word problems and logic-based questions.
"""
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .chatGPT:
            return "XCA ChatGPT"
            
        case .palm:
            return "XCA PaLMChat"
        }
    }
    
    var imageName: String {
        switch self {
        case .chatGPT:
            return "openai"
        case .palm:
            return "palm"
        }
    }
}
