//
//  TokenizerView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 28/03/23.
//

import SwiftUI

struct TokenizerView: View {
    
    @StateObject var vm = TokenizerViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        List {
            inputSection
            outputSection
        }
        .navigationTitle("GPT Tokenizer")
    }
    
    var inputSection: some View {
        Section {
            TextField("Enter text to tokenize", text: $vm.inputText, axis: .vertical)
                .focused($isFocused)
                .lineLimit(4...12)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
                }
            
            HStack {
                Button("Clear") {
                    withAnimation {
                        vm.inputText = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.inputText.isEmpty)
                
                Button("Show example") {
                    withAnimation {
                        vm.inputText = exampleText
                        isFocused = false
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.inputText == exampleText)
                
                Spacer()
                
                if vm.isTokenizing {
                    ProgressView()
                }
                
            }
            .padding(.vertical, 2)
        } header: {
            Text("Input")
        }
        
    }
    
    var outputSection: some View {
        Section {
            if let output = vm.output {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Text("Tokens").font(.subheadline)
                            Text("\(output.tokens.count)").font(.headline)
                        }
                        
                        Divider()
                            .frame(height: 32)
                        
                        VStack {
                            Text("Characters").font(.subheadline)
                            Text("\(output.text.count)").font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Picker("Output Type", selection: $vm.outputType) {
                        Text("Text").tag(OutputType.text)
                        Text("Token Ids").tag(OutputType.tokenIds)
                    }
                    .pickerStyle(.segmented)
                    
                    switch vm.outputType {
                    case .text:
                        TextView(output: output)
                            .frame(height: 240)
                        
                    case .tokenIds:
                        Text("\(output.tokens.description)")
                            .textSelection(.enabled)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                    }
                }
            }
        } header: {
            if vm.output != nil {
                Text("Output")
            }
        } footer: {
            Text(footerText).padding(.top, vm.output != nil ? 8 : 0)
        }
    }
}

struct TokenizerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TokenizerView()
        }
    }
}



let exampleText = """
        Many words map to one token, but some don't: indivisible.
        
        Unicode characters like emojis may be split into many tokens containing the underlying bytes: 🤚🏾
        
        Sequences of characters commonly found next to each other may be grouped together: 1234567890
        """


let footerText = """
        The GPT family of models process text using tokens, which are common sequences of characters found in text. The models understand the statistical relationships between these tokens, and excel at producing the next token in a sequence of tokens.
        
        You can use this tool to understand how a piece of text would be tokenized by the API, and the total count of tokens in that piece of text.
        
        A helpful rule of thumb is that one token generally corresponds to ~4 characters of text for common English text. This translates to roughly ¾ of a word (so 100 tokens ~= 75 words).
        
        if your input contains one or more unicode characters that map to multiple tokens. The output visualization may display the bytes in each token in a non-standard way.
        
        If you need a programmatic interface for tokenizing text, check out the GPTEncoder SPM or Cocoapods lib for Swift.
        """
