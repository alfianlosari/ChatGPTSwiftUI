//
//  XCAChatGPTWatchApp.swift
//  XCAChatGPTWatch Watch App
//
//  Created by Alfian Losari on 05/02/23.
//

import SwiftUI

@main
struct XCAChatGPTWatch_Watch_AppApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "API_KEY"))
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(vm: vm)
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup {
                            HStack {
                                Button("Send") {
                                    self.presentInputController(withSuggestions: []) { result in
                                        Task { @MainActor in
                                            guard !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                                            vm.inputMessage = result.trimmingCharacters(in: .whitespacesAndNewlines)
                                            await vm.sendTapped()
                                        }
                                    }
                                }
                                
                                Button("Clear", role: .destructive) {
                                    vm.clearMessages()
                                }
                                .tint(.red)
                                .disabled(vm.isInteractingWithChatGPT || vm.messages.isEmpty)
                            }
                            .padding(.bottom)
                        }
                    }
            }
        }
    }
}

extension App {
    typealias StringCompletion = (String) -> Void
    
    func presentInputController(withSuggestions suggestions: [String], completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: suggestions,
                                        allowedInputMode: .plain) { result in
                
                guard let result = result as? [String], let firstElement = result.first else {
                    completion("")
                    return
                }
                
                completion(firstElement)
            }
    }
}
