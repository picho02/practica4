//
//  DetalleViewController.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//

import UIKit
import Messages
import MessageUI
import FirebaseAuth
class DetalleViewController: UIViewController {

    let scroll = UIScrollView()
    let nombre = UILabel()
    let labelIngredientes = UILabel()
    let ingredientes = UILabel()
    let labelInstrucciones = UILabel()
    let instrucciones = UILabel()
    let btnShare = UIButton()
    var imagen = UIImageView()
    var bebida = Bebidas()
      
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        /*name.text = bebida["name"] ?? ""
          ingredientes.text = bebida["ingredients"] ?? ""
        instrucciones.text = bebida["directions"] ?? ""
        image.image = UIImage(named:(bebida["image"] ?? "drink"))
          */
    }

    override func viewDidLoad() {
      super.viewDidLoad()
        print(bebida.image)
        if (cargaImagenLocal(bebida.image!)){
            print("texto cargado desde local")
        }else{
        imagen.image = UIImage(named: (bebida.image ?? "drink"))
        }
        nombre.text = bebida.name ?? ""
        nombre.textAlignment = .center
        nombre.font = nombre.font.withSize(25)
        labelIngredientes.text = "Ingredientes:"
        ingredientes.text = bebida.ingredients ?? ""
        labelInstrucciones.text = "Instrucciones:"
        instrucciones.text = bebida.directions ?? ""
        imagen.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        btnShare.setTitle("Compartir", for: .normal)
        btnShare.backgroundColor = .blue
        btnShare.addTarget(self, action: #selector(compartir), for: .touchUpInside)
        self.view.addSubview(scroll) // peleé 2 horas con el codigo por olvidar esta linea
        scroll.addSubview(imagen)
        scroll.addSubview(nombre)
        scroll.addSubview(labelIngredientes)
        scroll.addSubview(btnShare)
        labelIngredientes.font = labelIngredientes.font.withSize(20)
        scroll.addSubview(ingredientes)
        ingredientes.font = ingredientes.font.withSize(15)
        ingredientes.numberOfLines = 3
        scroll.addSubview(labelInstrucciones)
        labelInstrucciones.font = labelInstrucciones.font.withSize(20)
        scroll.addSubview(instrucciones)
        instrucciones.font = instrucciones.font.withSize(15)
        instrucciones.numberOfLines = 25
        scroll.translatesAutoresizingMaskIntoConstraints = false
        nombre.translatesAutoresizingMaskIntoConstraints = false
        labelIngredientes.translatesAutoresizingMaskIntoConstraints = false
        ingredientes.translatesAutoresizingMaskIntoConstraints = false
        labelInstrucciones.translatesAutoresizingMaskIntoConstraints = false
        instrucciones.translatesAutoresizingMaskIntoConstraints = false
        imagen.translatesAutoresizingMaskIntoConstraints = false
        btnShare.translatesAutoresizingMaskIntoConstraints = false

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            nombre.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
            nombre.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            nombre.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            imagen.topAnchor.constraint(equalTo: nombre.bottomAnchor, constant: 20),
            imagen.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            imagen.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.6),
            imagen.heightAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.6),
            //imagen.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -32)
        ])
        NSLayoutConstraint.activate([
            labelIngredientes.topAnchor.constraint(equalTo: imagen.bottomAnchor, constant: 20),
            labelIngredientes.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            labelIngredientes.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            ingredientes.topAnchor.constraint(equalTo: labelIngredientes.bottomAnchor, constant: 20),
            ingredientes.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            ingredientes.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            labelInstrucciones.topAnchor.constraint(equalTo: ingredientes.bottomAnchor, constant: 20),
            labelInstrucciones.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            labelInstrucciones.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            instrucciones.topAnchor.constraint(equalTo: labelInstrucciones.bottomAnchor, constant: 20),
            instrucciones.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            instrucciones.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            btnShare.topAnchor.constraint(equalTo: instrucciones.bottomAnchor, constant: 20),
            btnShare.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            btnShare.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        scroll.contentLayoutGuide.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: 0).isActive = true
        scroll.contentLayoutGuide.heightAnchor.constraint(equalTo:scroll.frameLayoutGuide.heightAnchor, constant: 20).isActive = true
    }
    func cargaImagenLocal(_ nombre: String)-> Bool{
        let urlAdocs = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        if (FileManager.default.fileExists(atPath: urlAlArchivo.path))
        {
            
            do{
                let bytes = try Data(contentsOf: urlAlArchivo)
                let image = UIImage(data: bytes)
                self.imagen.image = image
            }
            catch{
                print(error.localizedDescription)
            }
           return true
            
       }else {
           return false
       }
    }
    @objc func compartir(){
        let defaults = UserDefaults.standard
        var email = defaults.value(forKey: "email") as? String
        print(email)
        if MFMailComposeViewController.canSendMail() {
            
            let mvc = MFMailComposeViewController()
            mvc.setToRecipients(["\(email)"])
            mvc.setMessageBody("Mira lo que prepare", isHTML: false)
            let imgData = imagen.image!.pngData()
            mvc.addAttachmentData(imgData!, mimeType:"image/png", fileName:bebida.image!)
            mvc.setSubject(bebida.name!)
            self.present(mvc, animated: true)
        }
        else {
            // PARA COMPARTIR A TODAS LAS APPS COMPATIBLES CON ActivityViewController
            let objetosParaCompartir:[Any] = [bebida.name, imagen.image]
            // el argumento "applicationActivities se usa para especificar a que apps queremos compartir, o si preferimos usar la configuración actual del usuario, pasamos nil
            let ac = UIActivityViewController(activityItems:objetosParaCompartir, applicationActivities: nil)
            self.present(ac, animated: true)
        }
    }
}
