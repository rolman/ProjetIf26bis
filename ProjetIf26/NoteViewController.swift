//
//  NoteViewController.swift
//  ProjetIf26
//
//  Created by if26-grp1 on 19/12/2017.
//  Copyright © 2017 if26-grp1. All rights reserved.
//

import UIKit
import SQLite

class NoteViewController: UIViewController {
    
    var dataBase: Connection!
    
    let dataTable = Table("itemsList")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let parentId = Expression<Int>("parentId")
    let type = Expression<String>("type")
    let content = Expression<String>("content")
    
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var noteContent: UILabel!
    var noteId:Int = 0
    var currentParentId = 0

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
        do{
            let data = try self.dataBase.prepare(self.dataTable.filter(self.id == noteId))
            
            for x in data{
                print(x[self.parentId])
                noteContent.text! = x[self.content]
                noteName.text! = String(x[self.name])
                currentParentId = x[self.parentId]
            }
            
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            vc?.toModifyId = self.noteId
        }
        if segue.destination is ViewController
        {
            let vc = segue.destination as? ViewController
            vc?.currentParentId = self.currentParentId
        }
    }

    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)

    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        performSegue(withIdentifier: "returnToListSegue", sender: self)

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
