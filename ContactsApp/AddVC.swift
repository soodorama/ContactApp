//
//  AddVC.swift
//  ContactsApp
//
//  Created by Neil Sood on 9/19/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit

protocol AddVCDelegate: class {
    func cancelPressed()
    func savePressed(data: [String:String])
}

class AddVC: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    
    var delegate: AddVCDelegate?
    var data: [String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        data["first"] = firstNameField.text
        data["last"] = lastNameField.text
        data["occupation"] = occupationField.text
        data["number"] = numberField.text
        
        delegate?.savePressed(data: data)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelPressed()
    }

}
