//
//  XCAChatGPTTVApp.swift
//  XCAChatGPTTV
//
//  Created by Alfian Losari on 05/02/23.
//

import SwiftUI

@main
struct XCAChatGPTTVApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "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"), enableSpeech: true)
    
    @FocusState var isTextFieldFocused: Bool
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("XCA ChatGPT").font(.largeTitle)
                HStack(alignment: .top) {
                    ContentView(vm: vm)
                        .cornerRadius(32)
                        .overlay {
                            if vm.messages.isEmpty {
                                Text("Click send to start interacting with ChatGPT")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                    .foregroundColor(Color(UIColor.placeholderText))
                            } else {
                                EmptyView()
                            }
                        }
                    
                    VStack {
                        TextField("Send", text: $vm.inputMessage)
                        .multilineTextAlignment(.center)
                        .frame(width: 176)
                        .focused($isTextFieldFocused)
                        .disabled(vm.isInteractingWithChatGPT)
                        .onSubmit {
                            Task { @MainActor in
                                await vm.sendTapped()
                                isTextFieldFocused = true
                            }
                        }
                        .onChange(of: isTextFieldFocused) { _  in
                            vm.inputMessage = ""
                        }
                        
                        Button("Clear", role: .destructive) {
                            vm.clearMessages()
                        }
                        .frame(width: 176)
                        .disabled(vm.isInteractingWithChatGPT || vm.messages.isEmpty)
                        
                        
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding()
                            .opacity(vm.isInteractingWithChatGPT ? 1 : 0)
                        
                    }
                }
            }
        }
    }
}
