//
//  AddFolderViewController.swift
//  ProjetIf26
//
//  Created by if26-grp1 on 18/12/2017.
//  Copyright © 2017 if26-grp1. All rights reserved.
//

import UIKit
import SQLite

class AddFolderViewController: UIViewController {
    
    var dataBase: Connection!
    
    let dataTable = Table("itemsList")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let parentId = Expression<Int>("parentId")
    let type = Expression<String>("type")
    let content = Expression<String>("content")

    @IBOutlet weak var folderName: UITextField!
    @IBOutlet weak var createFolderButton: UIButton!
    
    var currentParentId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("itemsList").appendingPathExtension("sqlite3")
            let dataBase = try Connection(fileUrl.path)
            self.dataBase = dataBase
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createFolder(_ sender: Any) {
    
        print("Bouton insert")
        
        //let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        //alert.addTextField {(tf) in tf.placeholder = "Name"}
        //alert.addTextField {(tf) in tf.placeholder = "Email"}
        //let action = UIAlertAction(title: "Submit", style: .default){(_) in guard
        
        //else {return}
        //print (name)
        //print (email)
        let folderNameText = folderName.text!
        print("Name : " + folderNameText)
        let insertData = self.dataTable.insert(self.name <- folderNameText , self.parentId <- currentParentId, self.type <- "folder", self.content <- "")
        
        do{
            try self.dataBase.run(insertData)
            print("folder inserted !")
            print("Name : " + folderNameText)
            print("parentId : " , currentParentId)
        }catch{
            print(error)
        }
        performSegue(withIdentifier: "createFolderSegue", sender: self)
    }
    
    @IBAction func `return`(_ sender: Any) {
        performSegue(withIdentifier: "createFolderSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController
        {
            let vc = segue.destination as? ViewController
            vc?.currentParentId = self.currentParentId
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
