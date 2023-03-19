//
//  XCAChatGPTMacApp.swift
//  XCAChatGPTMac
//
//  Created by Alfian Losari on 04/02/23.
//

import SwiftUI

@main
struct XCAChatGPTMacApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI())
    
    @State private var inputText = ""
    @State private var showingPrompt = false
    
//    init() {
//        // Get the app's Dock tile
//        let dockTile = NSApp.dockTile
//
//        // Set the Dock tile's view to an empty NSView
//        dockTile.contentView = NSView(frame: .zero)
//
//        // Set the activation policy to accessory
//        NSApp.setActivationPolicy(.accessory)
//    }
    
    var body: some Scene {
        MenuBarExtra("ChatGPT", image: "icon") {
            VStack(spacing: 0) {
                HStack {
                    Text("ChatGPT")
                        .font(.title2)
                    Spacer()
                    
                    Button("Set API key") {
                        showingPrompt = true
                    }
                    .contentShape(Rectangle())
                   
                    Button {
                        guard !vm.isInteractingWithChatGPT else { return }
                        vm.clearMessages()
                    } label: {
                        Image(systemName: "trash")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.borderless)
                    
                    
                    Button {
                        exit(0)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 16))
                    }

                    .buttonStyle(.borderless)
                }
                .padding()
                
                ContentView(vm: vm)
            }
            .frame(width: 480, height: 576)
            .sheet(isPresented: $showingPrompt) {
                VStack {
                    TextField("Enter OpenAI API Key here", text: $inputText).padding()
                    Button("OK") {
                        ChatGPT.apiToken = inputText
                        showingPrompt = false
                    }
                }.frame(width: 300, height: 90)
            }
        }.menuBarExtraStyle(.window)
    }
}
