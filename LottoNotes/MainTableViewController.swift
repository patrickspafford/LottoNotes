//
//  MainTableViewController.swift
//  LottoNotes
//
//  Created by Patrick Spafford on 9/30/20.
//  Copyright © 2020 Patrick Spafford. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var addNewNoteButton: UIBarButtonItem!
    
    @IBOutlet var pageTitle: UILabel!
    private var notes: [Note]!
    let mainTableIdentifier = "mainTableIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Optima", size: 20)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        shuffleNotes()
        tableView.reloadData()
        pageTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        pageTitle.text = "My LottoNotes"
        pageTitle.font = UIFont(name: "Optima", size: 25)
        pageTitle.textAlignment = .center
        self.navigationItem.titleView = pageTitle
        randomNote()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shuffleNotes()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    func shuffleNotes() {
        notes = NotesList.sharedNotesList.notes
        notes.shuffle()
    }
    func randomNote() {
        let randomFloat = Float.random(in: 0..<1)
        if randomFloat < UserDefaults.standard.float(forKey: "chanceOfReadingOldNote") {
            let randomTableCellIndex = Int.random(in: 0..<notes.count)
            let indexPath = IndexPath(row: randomTableCellIndex, section: 0)
            performSegue(withIdentifier: "RandomNote", sender: tableView.cellForRow(at: indexPath))
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainTableIdentifier, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "Optima", size: 22)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "h:mm a E, d MMM y"
        let dateString = dateFormatter.string(from: notes[indexPath.row].date)
        cell.detailTextLabel?.font = UIFont(name: "Optima", size: 12)
        cell.detailTextLabel?.text = dateString
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NotesList.sharedNotesList.deleteNote(note: notes[indexPath.row])
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewNote" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let noteVC = segue.destination as! NoteViewController
            let selectedNote = notes[indexPath.row]
            noteVC.navigationItem.rightBarButtonItem?.title = "Save"
            noteVC.previousBody = selectedNote.body
            noteVC.uuid = selectedNote.uuid
            noteVC.isEdit = true
            noteVC.previousTitle = selectedNote.title
        }
        else if segue.identifier == "RandomNote" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let noteVC = segue.destination as! NoteViewController
            let selectedNote = notes[indexPath.row]
            noteVC.navigationItem.title = selectedNote.title
            noteVC.navigationItem.rightBarButtonItem?.title = "I read it"
            noteVC.previousBody = selectedNote.body
            noteVC.uuid = selectedNote.uuid
            noteVC.isRandom = true
            noteVC.previousTitle = selectedNote.title
        }
        else {
            let noteVC = segue.destination as! NoteViewController
            let df = DateFormatter()
            df.dateStyle = .short
            let today = Date()
            let dateString = df.string(from: today)
            noteVC.previousTitle = "New Note \(dateString)"
            noteVC.navigationItem.rightBarButtonItem?.title = "Done"
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
