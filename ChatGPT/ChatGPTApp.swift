//
//  XCAChatGPTApp.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI

@main
struct XCAChatGPTApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI())
    
    @State private var inputText = ""
    @State private var showingPrompt = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(vm: vm)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Set API Key") {
                                showPrompt()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Clear") {
                                vm.clearMessages()
                            }
                            .disabled(vm.isInteractingWithChatGPT)
                        }
                    }
            }
        }
    }
    
    func showPrompt() {
        let alertController = UIAlertController(title: "OpenAI API Key", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Enter OpenAI API Key here"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let text = textField.text {
                ChatGPT.apiToken = text
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
