//
//  ViewController.swift
//  Notas
//
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Creacion del archivo defaults
    let dataDefault = UserDefaults.standard
    
    var posicion: Int?
    var noteSelect : String?
    var notes : [String] = ["Nota 1","Nota 2","Nota 3"]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Consultamos si existe algun valor en el UserDefaults
        if let notesSave = dataDefault.array(forKey: "ListNotes") as? [String] {
            notes = notesSave
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let notesSave = dataDefault.array(forKey: "ListNotes") as? [String] {
            notes = notesSave
        }
        tableView.reloadData()
    }
    
    // MARK: - Metodos del TableView
    
    // Retorna la cantidad de renglones de la TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Contenido de las celdas del TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fecha = Date()
        
        // Crear objeto de tipo UITableViewCell (Por defecto)
        let objCelda = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        objCelda.textLabel?.text = notes[indexPath.row]
        objCelda.detailTextLabel?.text = "Fecha de creacion: \(fecha)"
        
        // Regresamos el contenido de las celdas
        return objCelda
    }
    
    // Cuando el usuario selecciona un elemento
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtenemos el valor de la celda seleccionada
        posicion = indexPath.row
        noteSelect = notes[indexPath.row]
        
        // Enviar por segue la nota
        self.performSegue(withIdentifier: "SendNote", sender: self)
    }
    
    // Envio de datos por el Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendNote" {
            let destination = segue.destination as! NoteViewController
            destination.note = noteSelect
            destination.notes = notes
            destination.posicion = posicion
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Boton eliminacion de data
        let deleteRowAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, completion) in
            
            // Eliminar el elemento seleccesionado del arreglo
            self.notes.remove(at: indexPath.row)
            
            // Actualizamos la data
            self.tableView.reloadData()
            
            // LLamado a la funcion saveDefaults
            self.saveDefaults()
            
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteRowAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    // Almacenar la nueva data
    func saveDefaults(){
        // Guarda el arreglo alumnos en el archivo Defaults
        self.dataDefault.set(self.notes, forKey: "ListNotes")
    }
    
    var textView = UITextView(frame: CGRect.zero)

    @IBAction func addNotes(_ sender: Any) {
        let alertController = UIAlertController(title: "Nueva nota \n\n\n\n\n", message: nil, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Crear", style: .default) { (action) in
            // Validar que el textView No este vacio
            if self.textView.text == "" {
                let alertEmpty = UIAlertController(title: "Error", message: "No es posible crear una nota vacia", preferredStyle: .alert)
                
                alertEmpty.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertEmpty, animated: true)
            } else {
                // Agregamos a la data de la nueva nota
                self.notes.append(self.textView.text!)
                // LLamado a la funcion saveDefaults
                self.saveDefaults()
                // Refrescamos la data una vez agregada la nota
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancelar", style: .default) { (action) in
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        
        // Agregar acciones al alert
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        // Propiedades del TextView
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        textView.backgroundColor = UIColor.white
        textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
        alertController.view.addSubview(self.textView)

        // Mostramos el alert
        self.present(alertController, animated: true, completion: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = 90

                textView.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
}
