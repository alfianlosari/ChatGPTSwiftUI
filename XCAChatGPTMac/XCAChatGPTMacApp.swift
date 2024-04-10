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
    @State var llmConfig: LLMConfig?
    
    var body: some Scene {
        MenuBarExtra(vm.title, systemImage: "bubbles.and.sparkles") {
            VStack(spacing: 16) {
                HStack {
                    Text(vm.title).font(.title)
                    Spacer()
                    
                    Button {
                        exit(0)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 24))
                    }

                    .buttonStyle(.borderless)
                }.padding()
                
                LLMConfigView { config in
                    vm.updateClient(config.createClient())
                    llmConfig = config
                }
            }
            .frame(width: 480, height: 648)

            .sheet(item: $llmConfig) { _ in
                VStack(spacing: 0) {
                    HStack {
                        Text(vm.navigationTitle)
                            .font(.title)
                        Spacer()
                        
                        Button("Switch LLM", role: .destructive) {
                            llmConfig = nil
                        }
                       
                        Button {
                            guard !vm.isInteracting else { return }
                            vm.clearMessages()
                        } label: {
                            Image(systemName: "trash")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 24))
                        }

                        .buttonStyle(.borderless)
                    }
                    .padding()
                    
                    ContentView(vm: vm)
                }
                .frame(width: 480, height: 648)
            }
        }.menuBarExtraStyle(.window)
    }
}

