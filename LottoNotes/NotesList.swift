//
//  NotesList.swift
//  LottoNotes
//
//  Created by Patrick Spafford on 9/30/20.
//  Copyright © 2020 Patrick Spafford. All rights reserved.
//

import Foundation

class NotesList: Codable {
    static var sharedNotesList = NotesList()
    private(set) var notes: [Note]
    var notesKey = "notesKey"
    
    init() {
        let defaults = UserDefaults.standard
        notes = [Note(noteTitle: "Untitled", noteBody: "")]
        guard let notesData = defaults.object(forKey: notesKey) as? Data else {
            print("Load notes data failed.")
            return
        }
        guard let notesList = try? PropertyListDecoder().decode([Note].self, from: notesData) else {
            print("Property list decoder failed")
            return
        }
        notes = notesList
    }
    
    private func saveNotes() {
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(notes), forKey: notesKey)
        defaults.synchronize()
    }
    
    func addNote(note: Note) {
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    func deleteNote(note: Note) {
        let noteIds = NotesList.sharedNotesList.notes.map { $0.uuid }
        if let index = noteIds.firstIndex(of: note.uuid) {
            NotesList.sharedNotesList.notes.remove(at: index)
            saveNotes()
        }
    }
    
    func editNote(editedNote: Note, prevId: String) {
        let noteIds = NotesList.sharedNotesList.notes.map { $0.uuid }
        if let index = noteIds.firstIndex(of: prevId) {
            NotesList.sharedNotesList.notes[index] = editedNote
            saveNotes()
        }
        
    }
}
