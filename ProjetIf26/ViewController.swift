//
//  ViewController.swift
//  ProjetIf26
//
//  Created by if26-grp1 on 12/12/2017.
//  Copyright © 2017 if26-grp1. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var dataBase: Connection!
    
    let dataTable = Table("itemsList")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let parentId = Expression<Int>("parentId")
    let type = Expression<String>("type")
    let content = Expression<String>("content")
    var currentParentId = 0
    
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var sections: [String] = []
    var element: [String] = []
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previousFolderButton: UIButton!
    @IBOutlet weak var idOfTheCurrentFolder: UILabel!
    var toModifyId = 0
    
    
    @IBAction func deleteElement(_ sender: Any) {
      //  let current = tableView.cellForRow(at: <#T##IndexPath#>)
        print("delete")
        listData(idToLoad: currentParentId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("calcul section")
        return element.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("calculcell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellElement", for: indexPath) as! TableViewCell//1.
        
        do{
                let data = try self.dataBase.prepare(self.dataTable.filter(self.id == Int(element[indexPath.row])!))
                for x in data{
                    print(x[self.parentId])
                    cell.elementName.text! = x[self.name] //3.
                    cell.elementId = x[self.id]
                    cell.imageName.image = UIImage(named: x[self.type] + "_icon")
                    if(x[self.type] == "folder"){
                        cell.contentView.backgroundColor = UIColor.white
                    }
                }
                    
            } catch {
                print(error)
            }
        
            
    
          
        
        //let text = element[indexPath.row] //2.
        //let text = data[self.name]
        
        
        
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellElement", for: indexPath) as! TableViewCell//1.
        cell.contentView.removeFromSuperview()
        do{
            let data = try self.dataBase.prepare(self.dataTable.filter(self.id == Int(element[indexPath.row])!))
            for x in data{
                print("coucou")
                toModifyId = x[self.id]
                cell.elementName.text! = x[self.name] //3.
                cell.elementId = x[self.id]
                
                if(x[self.type] == "folder"){
                    currentParentId = x[self.id]
                    print("folder ", currentParentId)
                    //idOfTheCurrentFolder.text! = String(currentParentId)
                    listData(idToLoad: currentParentId)
                }
                else{
                    print("note selected")
                    performSegue(withIdentifier: "noteViewSegue", sender: self)
                }
            }
            
        } catch {
            print(error)
        }
        
        
        
    }
   
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "editFolderSegue", sender: self)
    }
    
    
    
    
    
    /*@IBAction func addFolderButton(_ sender: Any) {
        
           print("Bouton insert")
            let alert = UIAlertController(title: "Insert folder", message: nil, preferredStyle: .alert)
            alert.addTextField {(tf) in tf.placeholder = "Name"}
            let action = UIAlertAction(title: "Submit", style: .default){(_) in guard
                let name = alert.textFields?.first?.text
                else {return}
                print (name)
                let insertUser = self.dataTable.insert(self.name <- name , self.parentId <- 0, self.type <- "folder", self.content <- "")
                
                do{
                    try self.dataBase.run(insertUser)
                    print("Folder inserted ! ")
                    
                }catch{
                    print(error)
                }
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
        listData()
        
    }*/
    
    
    
    @IBAction func addFolderButton(_ sender: Any) {
        performSegue(withIdentifier: "addFolderSegue", sender: self)
    }
    
    @IBAction func addNoteButton(_ sender: Any) {
        performSegue(withIdentifier: "addNoteSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddNoteViewController
        {
            let vc = segue.destination as? AddNoteViewController
            vc?.currentParentId = self.currentParentId
        }
        if segue.destination is AddFolderViewController
        {
            let vc = segue.destination as? AddFolderViewController
            vc?.currentParentId = self.currentParentId
        }
        if segue.destination is NoteViewController
        {
            let vc = segue.destination as? NoteViewController
            vc?.noteId = self.toModifyId
        }
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            vc?.toModifyId = self.toModifyId
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*for i in 0...1000 {
            data.append("\(i)")
        }*/
        
        
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("itemsList").appendingPathExtension("sqlite3")
            let dataBase = try Connection(fileUrl.path)
            self.dataBase = dataBase
        } catch {
            print(error)
        }
        
        
        let createTable = self.dataTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.parentId, defaultValue: 0)
            table.column(self.type)
            table.column(self.content)
        }
        print ("test")
        
        do {
            try self.dataBase.run(createTable)
            print("Table created !")
        } catch {
            print(error)
        }
        listData(idToLoad: currentParentId)
        
        
        
        //let data = try self.dataBase.prepare("SELECT COUNT(*) from items WHERE id=1")
        //let data = dataTable.where(id == 1).count

        //print(data)
       // createTable()
    }
    
    @IBAction func createTable() {
        print("Bouton create")
        
        let createTable = self.dataTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.parentId, defaultValue: 0)
            table.column(self.type)
            table.column(self.content)
        }
        
        do {
            try self.dataBase.run(createTable)
            print("Table created !")
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func listData(idToLoad: Int) {
        print("Bouton list")
        
        do {
            let previousElements = try self.dataBase.prepare(self.dataTable.filter(self.id == currentParentId))
            for x in previousElements{
                folderName.text! = x[self.name]
                
            }
        }catch {
            print(error)
        }
        
        do {
            let elements = try self.dataBase.prepare(self.dataTable.filter(self.parentId == idToLoad))
            element = []
            for data in elements{
                if(data[self.parentId] == idToLoad){
                    element.append(String(data[self.id]))
                }
                
                print(String(data[self.parentId]))
                print("ok")
                
                if(currentParentId == 0 ){
                    previousFolderButton.isHidden = true
                    editButton.isHidden = true
                    folderName.text! = ""
                }else if (data[self.name] != ""){
                    previousFolderButton.isHidden = false
                   editButton.isHidden = false
                }
                
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    @IBAction func previousFolder(_ sender: Any) {
        do {
            let elements = try self.dataBase.prepare(self.dataTable.filter(self.id == currentParentId))
            element = []
            for data in elements{
                currentParentId = data[self.parentId]
                listData(idToLoad: data[self.parentId])
            }
        } catch {
            print(error)
        }
        
    }


}

