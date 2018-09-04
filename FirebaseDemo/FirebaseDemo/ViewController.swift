//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by 劉奕伶 on 2018/9/3.
//  Copyright © 2018年 Appwork School. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var tagText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    
    var email: String = ""
    var name: String = ""
    var titleField: String? = ""
    var tag: String = ""
    var content: String? = ""
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
//        removeData()
        
      
        
//        seeData()
        
        filter()
        

    }
    
    func removeData() {
        
        self.ref.child("user").child("user02").removeValue()
    }
    
    
    @IBAction func sendArticle(_ sender: Any) {
        
        createArticle()
    }
    
    func createArticle() {
        
        let key = ref.child("article").childByAutoId().key
        print(key)
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let dateString: String = dateFormat.string(from: now)
        
        content = contentText.text
        tag = tagText.text!
        titleField = titleText.text!
        
        
        let post = ["article_title": titleField,
                    "article_content": content,
                    "author": email,
                    "article_tag": tag,
                    "author_tag": "\(email)_\(tag)",
                    "created_time": dateString]
        
        let childUpdates = ["/article/\(key)": post]
        
        ref.updateChildValues(childUpdates)
    }
    
    @IBAction func goUser(_ sender: Any) {
        
        createUser()
    }
    
    func createUser() {
        
        let key = ref.child("user").childByAutoId().key
        
        email = emailText.text!
        name = nameText.text!
        
        let post = ["email": email,
                    "friends": "",
                    "username": name]
        
        let childUpdates = ["/user/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
    
    func seeData() {
        
        ref.child("article").observe(.value) { (snapshot) in
            print(snapshot)
        }
    }
    
    func filter() {
        
        ref.child("article").queryOrdered(byChild: "author_tag").queryEqual(toValue: "123456@gmail.com_表特").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

