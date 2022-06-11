//
//  ViewController.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var datos = [Bebidas]()
    var imagen = UIImage()
    @IBOutlet weak var tableView: UITableView!

    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Desea salir de la app", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        let btnNo = UIAlertAction(title: "si", style: .destructive){
            action in
            do{
            try Auth.auth().signOut()
                // obtenemos una referencia al SceneDelegate
                // podria haber mas de una escena en ipados o en Mac os
                let escena = UIApplication.shared.connectedScenes.first
                let sd = escena?.delegate as! SceneDelegate
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "email")
                defaults.synchronize()
                sd.cambiarVistaA("")
            }catch{
                
            }
        }
        alert.addAction(btnNo)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self


        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        tableView.reloadData()
        datos = appDel.todasLasBebidas()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }
    
    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "addBebida", sender: self)
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bebidasRow",for: indexPath)
        let bebida = datos[indexPath.row]
        cell.textLabel?.text = bebida.name
        if (cargaImagenLocal(bebida.image!)){
            cell.imageView?.image = imagen
        }else{
            cell.imageView?.image = UIImage(named:(bebida.image) ?? "\(indexPath.row)")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detalle", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        // Get the new view controller using segue.destination.
        if (segue.identifier! == "detalle"){
        let nuevoVC = segue.destination as! DetalleViewController
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let elDict = datos[indexPath.row] as Bebidas
            nuevoVC.bebida = elDict
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
        
    }
    func cargaImagenLocal(_ nombre: String)-> Bool{
        let urlAdocs = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)

        if (FileManager.default.fileExists(atPath: urlAlArchivo.path))
        {
            do{
                let bytes = try Data(contentsOf: urlAlArchivo)
                let image = UIImage(data: bytes)
                self.imagen = image!
                
            }
            catch{
                print(error.localizedDescription)
            }
           return true
            
       }else {
           return false
       }
    }
}

