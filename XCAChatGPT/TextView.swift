//
//  TextView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 28/03/23.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    
    let colors = [
        UIColor(red: 199/255, green: 195/255, blue: 212/255, alpha: 1),
        UIColor(red: 202/255, green: 236/255, blue: 202/255, alpha: 1),
        UIColor(red: 241/255, green: 218/255, blue: 181/255, alpha: 1),
        UIColor(red: 236/255, green: 180/255, blue: 180/255, alpha: 1),
        UIColor(red: 183/255, green: 219/255, blue: 241/255, alpha: 1)
    ]
    
    let output: TokenOutput
    
    func updateUIView(_ textView: UITextView, context: Context) {
        let attributedText = NSMutableAttributedString()
        output.stringTokens.enumerated().forEach { index, string in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .kern: 1,
                .backgroundColor: colors[index % colors.count],
            ]
            
            let attributedTokenText = NSAttributedString(string: string, attributes: attributes)
            attributedText.append(attributedTokenText)
            
        }
        textView.attributedText = attributedText
    }
        
    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        return tv
    }
    
}
