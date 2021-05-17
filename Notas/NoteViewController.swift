//
//  NoteViewController.swift
//  Notas
//
//

import UIKit

class NoteViewController: UIViewController {
    
    var note : String?
    var posicion: Int?
    var notes: [String]?
    let dataDefault = UserDefaults.standard
    
    @IBOutlet weak var noteTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        noteTextView.text = note
    }
    
    @IBAction func SaveNote(_ sender: UIButton) {
        // Eliminacion del areglo la nota a editar
        notes?.remove(at: posicion!)
        
        if let noteEdit = noteTextView.text {
            notes?.append(noteEdit)
        }
        
        dataDefault.set(notes, forKey: "ListNotes")
        navigationController?.popViewController(animated: true)
    }
}
