//
//  MainVC.swift
//  ContactsApp
//
//  Created by Neil Sood on 9/19/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var sections: [String] = []
    var tableData: [String:[Contact]] = [:]
    var contactData: [Contact] = [Contact]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchAllContacts()
        sortData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllContacts()
        sortData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEditSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let controller = nav.topViewController as! AddVC
        controller.delegate = self
    }
    
    func fetchAllContacts() {
        let request: NSFetchRequest = Contact.fetchRequest()
        do {
            let contacts = try context.fetch(request)
            contactData = contacts as [Contact]
        }
        catch {
            print("\(error)")
        }
    }
    
    func sortData() {
        // sort fetch items into table data dictionary from contact data array
        for contact in contactData {
            let firstLetter = String((contact.firstName?.first!)!)
            if sections.contains(firstLetter) {
                tableData[firstLetter]?.append(contact)
            }
            else {
                sections.append(firstLetter.uppercased())
                tableData[firstLetter] = [contact]
            }
        }
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numsections")
//        print(sections.count)
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("header title")
        return sections[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        print("sectiontitles")
//        print(sections)
//        sections = sections.sorted()
        return sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        if let _ = tableData[sections[section]] {
            return tableData[sections[section]]!.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let firstLetter = sections[indexPath.section]
        var nameStr = ""
        
        if let firstGuarded = tableData[firstLetter]![indexPath.row].firstName {
            nameStr += firstGuarded
        }
        if let lastGuarded = tableData[firstLetter]![indexPath.row].lastName {
            nameStr += " " + lastGuarded
        }
        
        cell.nameLabel.text = nameStr
        
        if let job = tableData[firstLetter]![indexPath.row].occupation {
            cell.occupationLabel.text = job
        }
        else {
            cell.occupationLabel.text = ""
        }
        print("cellforrowat")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
        }
        edit.backgroundColor = .green
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let key = self.sections[indexPath.section]
            let contact = self.tableData[key]![indexPath.row]
            self.context.delete(contact)
            
            do {
                try self.context.save()
            } catch {
                print("\(error)")
            }
            
            if self.tableData[key]!.count == 1 {
                self.tableData[key]!.remove(at: indexPath.row)
                self.tableData.removeValue(forKey: key)
            }
            else {
                self.tableData[key]!.remove(at: indexPath.row)
            }
            
            tableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
}

extension MainVC: AddVCDelegate {
    func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func savePressed(data: [String:String]) {
        // save to table
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
        contact.firstName = data["first"]
        contact.lastName = data["last"]
        contact.occupation = data["occupation"]
        contact.number = data["number"]
        
        let firstLetter = contact.firstName?.first
        
        if let _ = tableData[String(firstLetter!)] {
            print("hi")
            tableData[String(firstLetter!)]?.append(contact)
        }
        else {
            print([contact])
            sections.append(String(firstLetter!).uppercased())
            sections = sections.sorted()
            tableData[String(firstLetter!)] = [contact]
            print(tableData)
        }
        
        do {
            try context.save()
            print("SAVED")
        } catch {
            print("\(error)")
        }
        
        
//        tableView.reloadData()
        dismiss(animated: true, completion: nil)

    }
    
    
}


