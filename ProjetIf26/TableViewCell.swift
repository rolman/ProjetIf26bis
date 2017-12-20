//
//  TableViewCell.swift
//  ProjetIf26
//
//  Created by if26-grp1 on 19/12/2017.
//  Copyright © 2017 if26-grp1. All rights reserved.
//

import UIKit
import SQLite

class TableViewCell: UITableViewCell  {
    
    var dataBase: Connection!
    
    let dataTable = Table("itemsList")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let parentId = Expression<Int>("parentId")
    let type = Expression<String>("type")
    let content = Expression<String>("content")

    @IBOutlet weak var elementName: UILabel!
    @IBOutlet weak var editElement: UIButton!
    @IBOutlet weak var elementDelete: UIButton!
    @IBOutlet weak var imageName: UIImageView!
    var elementTitle = ""
    var elementContent = ""
    var elementId = 0
    var elementType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("itemsList").appendingPathExtension("sqlite3")
            let dataBase = try Connection(fileUrl.path)
            self.dataBase = dataBase
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func editElement(_ sender: Any) {
        do{
            let data = try self.dataBase.prepare(self.dataTable.filter(self.id == elementId))
            for x in data{
                print(x[self.parentId])
                elementTitle = x[self.name]
                elementContent = x[self.content]
                elementType = x[self.type]
                
                
            }
            
        } catch {
            print(error)
        }
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func deleteElement(_ sender: Any) {
        
        let data = self.dataTable.filter(self.id == elementId)
        let delData = data.delete()
        do{
            try self.dataBase.run(delData)
            print("data deleted !")
        }catch{
            print(error)
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
