//
//  Note.swift
//  LottoNotes
//
//  Created by Patrick Spafford on 9/30/20.
//  Copyright © 2020 Patrick Spafford. All rights reserved.
//

import Foundation

class Note: Codable {
    
    var title: String = "Untitled"
    let date: Date!
    var body: String!
    var uuid: String!
    
    init(noteTitle: String, noteBody: String) {
        title = noteTitle
        body = noteBody
        date = Date()
        uuid = UUID().uuidString
    }
    
}
