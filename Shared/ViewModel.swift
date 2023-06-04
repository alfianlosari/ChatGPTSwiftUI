//
//  ViewModel.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import Foundation
import SwiftUI
import AVKit

class ViewModel: ObservableObject {
    
    @Published var isInteracting = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    var task: Task<Void, Never>?
    
    #if !os(watchOS)
    private var synthesizer: AVSpeechSynthesizer?
    #endif
    
    private var api: LLMClient
    
    var title: String {
        "XCA LLM Chatbot"
    }
    
    var navigationTitle: String {
        api.provider.navigationTitle
    }
    
    init(api: LLMClient, enableSpeech: Bool = false) {
        self.api = api
        #if !os(watchOS)
        if enableSpeech {
            synthesizer = .init()
        }
        #endif
    }
    
    func updateClient(_ client: LLMClient) {
        self.messages = []
        self.api = client
    }
    
    @MainActor
    func sendTapped() async {
        #if os(iOS)
        self.task = Task {
            let text = inputMessage
            inputMessage = ""
            if api.provider == .chatGPT {
                await sendAttributed(text: text)
            } else {
                await sendAttributedWithoutStream(text: text)
            }
        }
        #else
        let text = inputMessage
        inputMessage = ""
        if api.provider == .chatGPT {
            await send(text: text)
        } else {
            await sendWithoutStream(text: text)
        }
        #endif
    }
    
    @MainActor
    func clearMessages() {
        stopSpeaking()
        api.deleteHistoryList()
        withAnimation { [weak self] in
            self?.messages = []
        }
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        #if os(iOS)
        self.task = Task {
            guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
                return
            }
            self.messages.remove(at: index)
            if api.provider == .chatGPT {
                await sendAttributed(text: message.sendText)
            } else {
                await sendAttributedWithoutStream(text: message.sendText)
            }
        }
        #else
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        if api.provider == .chatGPT {
            await send(text: message.sendText)
        } else {
            await sendWithoutStream(text: message.sendText)
        }
        #endif
    }
    
    func cancelStreamingResponse() {
        self.task?.cancel()
        self.task = nil
    }
    
    #if os(iOS)
    @MainActor
    private func sendAttributed(text: String) async {
        isInteracting = true
        var streamText = ""
        
        var messageRow = MessageRow(
            isInteracting: true,
            sendImage: "profile",
            send: .rawText(text),
            responseImage: api.provider.imageName,
            response: .rawText(streamText),
            responseError: nil)
    
        do {
            let parsingTask = ResponseParsingTask()
            let attributedSend = await parsingTask.parse(text: text)
            try Task.checkCancellation()
            messageRow.send = .attributed(attributedSend)
            
            self.messages.append(messageRow)
            
            let parserThresholdTextCount = 64
            var currentTextCount = 0
            var currentOutput: AttributedOutput?
            
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                currentTextCount += text.count
                
                if currentTextCount >= parserThresholdTextCount || text.contains("```") {
                    currentOutput = await parsingTask.parse(text: streamText)
                    try Task.checkCancellation()
                    currentTextCount = 0
                }

                if let currentOutput = currentOutput, !currentOutput.results.isEmpty {
                    let suffixText = streamText.trimmingPrefix(currentOutput.string)
                    var results = currentOutput.results
                    let lastResult = results[results.count - 1]
                    var lastAttrString = lastResult.attributedString
                    if lastResult.isCodeBlock {
                        lastAttrString.append(AttributedString(String(suffixText), attributes: .init([.font: UIFont.systemFont(ofSize: 12).apply(newTraits: .traitMonoSpace), .foregroundColor: UIColor.white])))
                    } else {
                        lastAttrString.append(AttributedString(String(suffixText)))
                    }
                    results[results.count - 1] = ParserResult(attributedString: lastAttrString, isCodeBlock: lastResult.isCodeBlock, codeBlockLanguage: lastResult.codeBlockLanguage)
                    messageRow.response = .attributed(.init(string: streamText, results: results))
                } else {
                    messageRow.response = .attributed(.init(string: streamText, results: [
                        ParserResult(attributedString: AttributedString(stringLiteral: streamText), isCodeBlock: false, codeBlockLanguage: nil)
                    ]))
                }

                self.messages[self.messages.count - 1] = messageRow
                if let currentString = currentOutput?.string, currentString != streamText {
                    let output = await parsingTask.parse(text: streamText)
                    try Task.checkCancellation()
                    messageRow.response = .attributed(output)
                }
            }
        } catch is CancellationError {
            messageRow.responseError = "The response was cancelled"
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        if messageRow.response == nil {
            messageRow.response = .rawText(streamText)
        }
  
        messageRow.isInteracting = false
        self.messages[self.messages.count - 1] = messageRow
        isInteracting = false
        speakLastResponse()
    }
    
    @MainActor
    private func sendAttributedWithoutStream(text: String) async {
        isInteracting = true
        var messageRow = MessageRow(
            isInteracting: true,
            sendImage: "profile",
            send: .rawText(text),
            responseImage: api.provider.imageName,
            response: .rawText(""),
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let responseText = try await api.sendMessage(text)
            try Task.checkCancellation()
            
            let parsingTask = ResponseParsingTask()
            let output = await parsingTask.parse(text: responseText)
            try Task.checkCancellation()
            
            messageRow.response = .attributed(output)
            
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteracting = false
        self.messages[self.messages.count - 1] = messageRow
        isInteracting = false
        speakLastResponse()

    }
    #endif
    
    @MainActor
    private func send(text: String) async {
        isInteracting = true
        var streamText = ""
        var messageRow = MessageRow(
            isInteracting: true,
            sendImage: "profile",
            send: .rawText(text),
            responseImage: api.provider.imageName,
            response: .rawText(streamText),
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                messageRow.response = .rawText(streamText.trimmingCharacters(in: .whitespacesAndNewlines))
                self.messages[self.messages.count - 1] = messageRow
            }
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteracting = false
        self.messages[self.messages.count - 1] = messageRow
        isInteracting = false
        speakLastResponse()
        
    }
    
    @MainActor
    private func sendWithoutStream(text: String) async {
        isInteracting = true
        var messageRow = MessageRow(
            isInteracting: true,
            sendImage: "profile",
            send: .rawText(text),
            responseImage: api.provider.imageName,
            response: .rawText(""),
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let responseText = try await api.sendMessage(text)
            try Task.checkCancellation()
            messageRow.response = .rawText(responseText)
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteracting = false
        self.messages[self.messages.count - 1] = messageRow
        isInteracting = false
        speakLastResponse()
    }
    
    func speakLastResponse() {
        #if !os(watchOS)
        guard let synthesizer, let responseText = self.messages.last?.responseText, !responseText.isEmpty else {
            return
        }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: responseText)
        utterance.voice = .init(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance )
        #endif
    }
    
    func stopSpeaking() {
        #if !os(watchOS)
        synthesizer?.stopSpeaking(at: .immediate)
        #endif
    }
    
}



