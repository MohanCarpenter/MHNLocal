//
//  ViewController.swift
//  MHNDataBase
//
//  Created by mac on 22/08/18.
//  Copyright © 2018 mhn. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var arrList: [NSManagedObject] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MHNLIST"
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =  appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MHNList")
        do {
            arrList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // latest
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: "Add a new entry", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                    return
            }
            
            self.saveNewName(name: nameToSave)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func saveNewName(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MHNList", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        arrList.append(person)
        self.tblView.reloadData()

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = arrList[indexPath.row]
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "MHNCell", for: indexPath) as! MHNCell
        if let title  = obj.value(forKey: "name") as? String {
            cell.lblTitle.text = title

        }else {
            cell.lblTitle.text = "N/A"

        }
        cell.btnCrose.tag = indexPath.row
        cell.btnCrose.addTarget(self, action: #selector(pressButtonCrose(_:)), for: .touchUpInside)

        return cell
    }
    //The target function
    @objc func pressButtonCrose(_ sender: UIButton){ //<- needs `@objc`
       // print("\(sender)")
        let obj = arrList[sender.tag]
        let Con = getContext()
        Con.delete(obj)
        arrList.remove(at: sender.tag)

        tblView.reloadData()

        do {
            try Con.save()
           
            tblView.reloadData()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}

