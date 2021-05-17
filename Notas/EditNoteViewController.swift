//
//  EditNoteViewController.swift
//  Notas
//
//  Created by Jose Angel Cortes Gomez on 14/05/21.
//

import UIKit

class EditNoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    var note : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        noteTextView.text = note
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
