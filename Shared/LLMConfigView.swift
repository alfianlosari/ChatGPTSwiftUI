//
//  LLMConfigView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 03/06/23.
//

import SwiftUI

struct LLMConfigView: View {
    
    let onStartChatTapped: (_ result: LLMConfig) -> Void
    @State var apiKey = ""
    @State var llmProvider = LLMProvider.chatGPT
    @State var chatGPTModel = ChatGPTModel.gpt3Turbo
    
    var body: some View {
        #if os(macOS)
        ScrollView { sectionsView }
            .padding(.horizontal)
        #else
        List { sectionsView }
        #endif
    }
    
    @ViewBuilder
    var sectionsView: some View {
        Section("LLM Provider") {
            Picker("Provider", selection: $llmProvider) {
                ForEach(LLMProvider.allCases) {
                    Text($0.text).id($0)
                }
            }
            #if !os(watchOS)
            .pickerStyle(.segmented)
            #endif
        }
        
        Section("Configuration") {
            TextField("Enter API Key", text: $apiKey)
                .autocorrectionDisabled()
                #if os(macOS)
                .textCase(.none)
                .textFieldStyle(.roundedBorder)
                #else
                .textInputAutocapitalization(.never)
                #endif
            
            if llmProvider == .chatGPT {
                Picker("Model", selection: $chatGPTModel) {
                    ForEach(ChatGPTModel.allCases) {
                        Text($0.text).id($0)
                    }
                }
                #if !os(watchOS)
                .pickerStyle(.segmented)
                #endif
            }
        }
        
        Section {
            Button("Start Chat") {
                let type: LLMConfig.ConfigType
                switch llmProvider {
                case .chatGPT:
                    type = .chatGPT(chatGPTModel)
                case .palm:
                    type = .palm
                }
                
                self.onStartChatTapped(.init(apiKey: apiKey, type: type))
            }
            #if os(macOS)
            .buttonStyle(.borderedProminent)
            #endif
            .frame(maxWidth: .infinity)
            .disabled(apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
        } footer: {
            Text(llmProvider.footerInfo)
                .padding(.vertical)
        }
    }
}

struct LLMConfigView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LLMConfigView { result in
                
            }
        }
    }
}

