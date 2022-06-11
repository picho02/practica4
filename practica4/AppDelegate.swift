//
//  AppDelegate.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//

import UIKit
import CoreData
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let ud = UserDefaults.standard
        let bandera = (ud.value(forKey: "infoOK") as? Bool) ?? false
        if !bandera{
            obtenerBebidas()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "practica4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func obtenerBebidas() {
        // TODO: Verificar que se tenga conexión a Internet ....
        // TODO: Cambiar el http-method a POST para que el apiKey no vaya visible
        if let rutaAlArchivo = Bundle.main.url(forResource: "Drinks", withExtension: "plist") {
            do {
                let bytes = try Data(contentsOf: rutaAlArchivo)
                let tmp = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format:nil)
                let datos = tmp as! [[String:String]]
                llenaBD(datos, entidad:"Bebidas")
                let ud = UserDefaults.standard
                ud.set(true, forKey: "infoOK")
                ud.synchronize()
            }
            catch {
                print ("no se pudo obtener la info desde el feed de Bebidas \(error.localizedDescription)")
            }
        }
    }
    func llenaBD(_ arreglo:[[String:String]], entidad:String) {
        // 0. requerimos la descripción de la entidad para poder crear objetos CD
        guard let entidadDesc = NSEntityDescription.entity(forEntityName:entidad, in:persistentContainer.viewContext)
        else {
            return
        }
        for dict in arreglo {
            // 1. crear un objeto Mascota
                let m = NSManagedObject(entity: entidadDesc, insertInto: persistentContainer.viewContext) as! Bebidas
                // 2. setear las properties del objeto, con los datos del dict
                m.inicializaCon(dict)
            
            // 3. salvar el objeto
            saveContext()
        }
    }
    func todasLasBebidas() -> [Bebidas] {
        var resultset = [Bebidas]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bebidas")
        do {
            let tmp = try persistentContainer.viewContext.fetch(request)
            resultset = tmp as! [Bebidas]
        }
        catch {
            print ("fallo el request \(error.localizedDescription)")
        }
        return resultset
    }
    func nuevaBebida(name: String, ingredients: String,directions:String,image:String) {
        let entidadDesc = NSEntityDescription.entity(forEntityName:"Bebidas", in:persistentContainer.viewContext)
        let p = NSManagedObject(entity: entidadDesc!, insertInto: persistentContainer.viewContext) as! Bebidas
        p.name = name
        p.image = image
        p.directions = directions
        p.ingredients = ingredients
    }

}

