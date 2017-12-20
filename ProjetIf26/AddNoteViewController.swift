//
//  AddNoteViewController.swift
//  ProjetIf26
//
//  Created by if26-grp1 on 12/12/2017.
//  Copyright © 2017 if26-grp1. All rights reserved.
//

import UIKit
import SQLite

class AddNoteViewController: UIViewController {
    
    var dataBase: Connection!
    
    let dataTable = Table("itemsList")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let parentId = Expression<Int>("parentId")
    let type = Expression<String>("type")
    let content = Expression<String>("content")


    @IBOutlet weak var noteContent: UITextView!
    @IBOutlet weak var noteName: UITextField!
    var textTest :String = ""
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
        print("parent ", currentParentId)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNote(_ sender: Any) {
        print("Bouton insert")
        
        let noteNameText = noteName.text!
        let noteContentText = noteContent.text!
        print("Name : " + noteNameText)
        print("Content : " + noteContentText)
        let insertData = self.dataTable.insert(self.name <- noteNameText , self.parentId <- currentParentId, self.type <- "note", self.content <- noteContentText)
        
        do{
            try self.dataBase.run(insertData)
            print("note inserted !")
            print("Name : " + noteNameText)
            print("Content : " + noteContentText)
            print("parentId : " , currentParentId)
        }catch{
            print(error)
        }
        performSegue(withIdentifier: "createNoteSegue", sender: self)
    }
    
    //alert.addAction(action)
    //present(alert, animated: true, completion: nil)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController
        {
            let vc = segue.destination as? ViewController
            vc?.currentParentId = self.currentParentId
        }
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


