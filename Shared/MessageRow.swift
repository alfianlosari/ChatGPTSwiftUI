//
//  MessageRow.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI

struct MessageRow: Identifiable {
    
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendImage: String
    let sendText: String
    
    let responseImage: String
    var responseText: String?
    
    var responseError: String?
    
}
