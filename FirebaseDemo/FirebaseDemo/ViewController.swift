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
    @IBOutlet weak var findFriendEmail: UITextField!
    @IBOutlet weak var userNotFound: UILabel!
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteName: UILabel!
    @IBOutlet weak var searchTag: UITextField!
    @IBOutlet weak var searchUser: UITextField!
    
    var email: String = ""
    var name: String = ""
    var titleField: String = ""
    var tag: String = ""
    var content: String = ""
    var friendEmail: String = ""
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
//        removeData()
        
//        seeData()
        
    }
    
    func removeData() {
        
        self.ref.child("user").child("user02").removeValue()
    }
    
    func filterFriend() {
        
        friendEmail = findFriendEmail.text!
        
        ref.child("user").queryOrdered(byChild: "email").queryEqual(toValue: friendEmail).observeSingleEvent(of: .value) { (snapshot) in
        print(snapshot)
            
            guard let value = snapshot.value as? NSDictionary else {
                print("no such value")
                self.userNotFound.isHidden = false
                return
            }
            
            guard let key = value.allKeys.first as? String else {
                print("no such key")
                return
            }
            
            guard let info = value[key] as? [String: Any] else {
                print("no such info")
                return
            }
            guard let nameInDic = info["username"] as? String else {
                return
            }
            
            self.inviteView.isHidden = false
            self.inviteName.text = nameInDic
        }
    }
    
    @IBAction func findFriend(_ sender: Any) {
        
        filterFriend()
    }
    
    @IBAction func sendArticle(_ sender: Any) {
        
        createArticle()
    }
    
    @IBAction func inviteAction(_ sender: Any) {
    }
    
    
    func createArticle() {
        
        let key = ref.child("article").childByAutoId().key
        print(key)
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let dateString: String = dateFormat.string(from: now)
        
        content = contentText.text!
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
    
    @IBAction func filterUserAndTag(_ sender: Any) {
        
        filterTagAndUser()
    }
    
    @IBAction func filterTag(_ sender: Any) {
        
        filterTag()
    }
    
    @IBAction func filterUser(_ sender: Any) {
        
        filterUser()
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
    
    func filterTagAndUser() {
        
        let user = searchUser.text!
        let filteredTag = searchTag.text!
        
        ref.child("article").queryOrdered(byChild: "author_tag").queryEqual(toValue: "\(user)_\(filteredTag)").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
        }
    }
    
    func filterTag() {
        
        ref.child("article").queryOrdered(byChild: "article_tag").queryEqual(toValue: searchTag.text).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
        }
    }
    
    func filterUser() {
        
        ref.child("article").queryOrdered(byChild: "author").queryEqual(toValue: searchUser.text).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

