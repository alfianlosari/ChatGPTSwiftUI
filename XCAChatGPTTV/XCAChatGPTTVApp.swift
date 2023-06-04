//
//  XCAChatGPTTVApp.swift
//  XCAChatGPTTV
//
//  Created by Alfian Losari on 05/02/23.
//

import SwiftUI

@main
struct XCAChatGPTTVApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "API_KEY"), enableSpeech: true)
    @State var llmConfig: LLMConfig?
    
    @FocusState var isTextFieldFocused: Bool
    
    var body: some Scene {
        WindowGroup {
            VStack(alignment: .center) {
                Text(vm.title).font(.largeTitle)
                LLMConfigView { config in
                    vm.updateClient(config.createClient())
                    llmConfig = config
                }
                .frame(width: 1280)
            }
            .opacity(llmConfig == nil ? 1 : 0)
            .fullScreenCover(item: $llmConfig) { _ in
                VStack {
                    Text(vm.navigationTitle).font(.largeTitle)
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
                            .disabled(vm.isInteracting)
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
                            .disabled(vm.isInteracting || vm.messages.isEmpty)
                            
                            Button("Switch LLM", role: .destructive) {
                                llmConfig = nil
                            }
                            .padding(.vertical)
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .padding()
                                .opacity(vm.isInteracting ? 1 : 0)
                        }
                    }
                }
                
            }
            
            
        
        }
    }
}

