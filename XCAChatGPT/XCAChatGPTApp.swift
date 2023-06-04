//
//  XCAChatGPTApp.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI

@main
struct XCAChatGPTApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
    @State var isShowingTokenizer = false
    @State var llmConfig: LLMConfig?
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LLMConfigView { config in
                    vm.updateClient(config.createClient())
                    llmConfig = config
                }
                .navigationTitle(vm.title)
            }
            .fullScreenCover(item: $llmConfig) { config in
                NavigationStack {
                    ContentView(vm: vm)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                if case .chatGPT = llmConfig?.type {
                                    Button("Tokenizer") {
                                        self.isShowingTokenizer = true
                                    }
                                    .disabled(vm.isInteracting)
                                }
                                
                                Button("Clear", role: .destructive) {
                                    vm.clearMessages()
                                }
                                .disabled(vm.isInteracting)
                            }
                            
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Switch LLM", role: .destructive) {
                                    llmConfig = nil
                                }
                            }
                        }
                }
                .fullScreenCover(isPresented: $isShowingTokenizer) {
                    NavigationTokenView()
                }
            }
        }
    }
}


struct NavigationTokenView: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TokenizerView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
        .interactiveDismissDisabled()
    }
}



