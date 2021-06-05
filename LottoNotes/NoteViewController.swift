//
//  NoteViewController.swift
//  LottoNotes
//
//  Created by Patrick Spafford on 10/1/20.
//  Copyright © 2020 Patrick Spafford. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var completeNote: UIBarButtonItem!
    @IBOutlet weak var noteBody: UITextView!
    var previousBody: String = ""
    var previousTitle: String = ""
    var isEdit: Bool = false
    var isRandom: Bool = false
    var uuid: String = ""
    var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        noteBody.text = previousBody
        noteBody.delegate = self
        configureTitle()
        if !isEdit || isRandom { // Cannot save empty notes
            completeNote.isEnabled = false
        }
        if isRandom {
            navigationItem.hidesBackButton = true // They must scroll down
        }
        self.navigationItem.titleView = textField
    }
    
    @IBAction private func textFieldDoneEditing(_ sender: Any) { // Single tap dismiss?
        textField.resignFirstResponder()
        noteBody.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRandom && !completeNote.isEnabled {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                completeNote.isEnabled = true
            }
        }
    }
    
    func configureTitle() {
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        textField.text = previousTitle
        textField.font = UIFont(name: "Arial", size: 25)
        textField.textAlignment = .center
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = (noteBody.text! as NSString).replacingCharacters(in: range, with: text)
        completeNote.isEnabled = !text.isEmpty
        return true
    }

    @IBAction func completeNoteAction(_ sender: Any) {
        let newNoteTitle: String = (textField.text == "" ? "Untitled" : textField.text) ?? "Untitled"
        let note = Note(noteTitle: newNoteTitle, noteBody: noteBody.text)
        if isEdit || isRandom {
            NotesList.sharedNotesList.editNote(editedNote: note, prevId: uuid)
        } else {
            NotesList.sharedNotesList.addNote(note: note)
        }
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
