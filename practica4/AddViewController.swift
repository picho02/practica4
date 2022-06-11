//
//  AddViewController.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    let scroll = UIScrollView()
    let titulo = UILabel()
    let name = UITextField()
    let directions = UITextField()
    let ingredients = UITextField()
    let addButton = UIButton()
    let btnCancel = UIButton()
    let camera = UIButton()
    let galeria = UIButton()
    let imagen = UIImageView()
    let temp = Bebidas()
    var imageToSafe = UIImage()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for view in scroll.subviews {
            if view is UITextField {
                let text = view as! UITextField
                text.borderStyle = .roundedRect
                text.backgroundColor = .white
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToSafe = UIImage(named: "drink")!
        imagen.image =  imageToSafe
        imagen.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        titulo.text = "Agregar nueva bebida"
        titulo.textAlignment = .center
        titulo.font = titulo.font.withSize(30)
        name.placeholder = "nombre"
        ingredients.placeholder = "ingredientes"
        directions.placeholder = "instrucciones"
        addButton.setTitle("Agregar", for: .normal)
        addButton.backgroundColor = .blue
        addButton.addTarget(self, action: #selector(guardarBebida), for: .touchUpInside)
        btnCancel.setTitle("cancelar", for: .normal)
        btnCancel.backgroundColor = .red
        btnCancel.addTarget(self, action: #selector(cancelar), for: .touchUpInside)
        camera.setTitle("Tomar foto", for: .normal)
        camera.backgroundColor = .blue
        camera.addTarget(self, action: #selector(tomarFoto), for: .touchUpInside)
        galeria.setTitle("Abrir galeria", for: .normal)
        galeria.backgroundColor = .blue
        galeria.addTarget(self, action: #selector(abrirGaleria), for: .touchUpInside)
        self.view.addSubview(scroll)
        scroll.addSubview(imagen)
        scroll.addSubview(titulo)
        scroll.addSubview(name)
        scroll.addSubview(ingredients)
        scroll.addSubview(directions)
        scroll.addSubview(addButton)
        scroll.addSubview(camera)
        scroll.addSubview(galeria)
        scroll.addSubview(btnCancel)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        titulo.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        ingredients.translatesAutoresizingMaskIntoConstraints = false
        directions.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        imagen.translatesAutoresizingMaskIntoConstraints = false
        camera.translatesAutoresizingMaskIntoConstraints = false
        galeria.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        
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
            titulo.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 30),
            titulo.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            titulo.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            imagen.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20),
            imagen.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            imagen.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.6),
            imagen.heightAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.6),

        ])
        NSLayoutConstraint.activate([
            camera.topAnchor.constraint(equalTo: imagen.bottomAnchor, constant: 20),
            camera.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            camera.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            galeria.topAnchor.constraint(equalTo: camera.bottomAnchor, constant: 20),
            galeria.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            galeria.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: galeria.bottomAnchor, constant: 20),
            name.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            name.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            ingredients.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            ingredients.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            ingredients.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            directions.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 20),
            directions.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            directions.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: directions.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
        NSLayoutConstraint.activate([
            btnCancel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            btnCancel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            btnCancel.widthAnchor.constraint(equalTo:scroll.widthAnchor, multiplier: 0.9)
        ])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @objc func guardarBebida(){
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (name.text == "" || name.text == " "){
            let alert = UIAlertController(title: "Falta nombre", message: "Agrege un nombre a su bebida", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (ingredients.text == " " || ingredients.text == ""){
            let alert = UIAlertController(title: "Faltan ingredientes", message: "Agrege ingredientes a su bebida", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (directions.text == "" || directions.text == " "){
            let alert = UIAlertController(title: "Faltan instrucciones", message: "Agrege Instrucciones a su bebida", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let nombreImagen = "\(name.text!.replacingOccurrences(of: " ", with: "")).jpeg"
            appDel.nuevaBebida(name: name.text ?? "", ingredients: ingredients.text ?? "", directions: directions.text ?? "", image: nombreImagen)
            appDel.saveContext()
            guardaImagen(imageToSafe.jpegData(compressionQuality: 1)!, nombreImagen)
            self.dismiss(animated: true)
        }
    }
    @objc func tomarFoto(){
        let ipc = UIImagePickerController()
        /* para trabajar con la galería
        ipc.sourceType = .photoLibrary
        */
        ipc.delegate = self
        // permitir edición
        ipc.allowsEditing = true
        // consultamos si la cámara esta disponible
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Se requiere la llave Privacy - Camer Usage Description en el archivo info.plist
            ipc.sourceType = .camera
            // Validar permiso de uso de la cámara
            let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized {
                self.present(ipc, animated: true,  completion: nil)
            }
            else {
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        if respuesta {
                            self.present(ipc, animated: true,  completion: nil)
                        }
                        else {
                            // cerrar la app?
                            // mostrar alert?
                            print ("no se que hacer  :(")
                        }
                    }
                }
                else {  // .denied
                    let alert = UIAlertController(title: "Error", message: "Debe autorizar el uso de la cámara desde el app de configuración. Quieres hacerlo ahora?", preferredStyle:.alert)
                    let btnSI = UIAlertAction(title: "Si, por favor", style: .default) { action in
                        // lanzar el app de settings:
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alert.addAction(btnSI)
                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {

            let alert = UIAlertController(title: "Camara no disponible", message: "Revise que su camara este funcionando correctamente", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func abrirGaleria(){
        let ipc = UIImagePickerController()
        /* para trabajar con la galería
        ipc.sourceType = .photoLibrary
        */
        ipc.delegate = self
        // permitir edición
        ipc.allowsEditing = true
        ipc.sourceType = .photoLibrary
        self.present(ipc, animated: true,  completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print ("seleccionó")
        if let imagenSeleccionada = info[.editedImage] as? UIImage {
            // Cambiar la resolución de la imagen
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), true, 0.75)
            imagenSeleccionada.draw(in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            let nuevaImagen = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageToSafe = nuevaImagen!
            imagen.image = imageToSafe
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("canceló")
        picker.dismiss(animated: true, completion: nil)
    }
    func guardaImagen(_ bytes:Data,_ nombre:String){
        let urlAdocs = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        do{
            try bytes.write(to: urlAlArchivo)
        }catch{
            print("no se pudo salvar la imagen")
        }
    }
    @objc func cancelar(){
        self.dismiss(animated: true)
    }

}
