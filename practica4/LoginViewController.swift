//
//  LoginViewController.swift
//  practica4
//
//  Created by Edgar Cruz Reyes on 10/06/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var a_i = UIActivityIndicatorView()
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBAction func btnEntrar(_ sender: Any) {
        a_i.startAnimating()
        Auth.auth().signIn(withEmail: self.txtUser.text!,password: self.txtPass.text!) { user, error in
            if error != nil{
                let alert = UIAlertController(title: "", message: "error \(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async {
                    self.a_i.stopAnimating()
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let defaults = UserDefaults.standard
                defaults.set(self.txtUser.text!, forKey: "email")
                defaults.synchronize()
                DispatchQueue.main.async {
                    self.a_i.stopAnimating()
                    self.performSegue(withIdentifier: "goHome", sender: nil)
                }
            }
        }
    }
    @IBAction func btnRegistrar(_ sender: Any) {
        let alert = UIAlertController(title: "Nuevo usuario", message: "introduce tus datos", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addTextField(configurationHandler: {txtEmail in
            txtEmail.placeholder = "Tu email"
        })
        alert.addTextField(configurationHandler: {txtPass in
            txtPass.placeholder = "6 caracteres o mas"
        })
        let btnEnviar = UIAlertAction(title: "Enviar", style: .default, handler: {action in
            guard let email = alert.textFields![0].text,
                  let pass = alert.textFields![1].text else {return}
                    Auth.auth().createUser(withEmail: email, password: pass) { auth, error in
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()
                        if error != nil{
                            print("ocurrio un error \(error!.localizedDescription)")
                        }
                    }
    })
        alert.addAction(btnEnviar)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        a_i.style = .large
        a_i.color = .red
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
        self.view.addSubview(a_i)
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
