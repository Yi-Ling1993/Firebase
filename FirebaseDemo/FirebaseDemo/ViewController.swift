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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.ref.child("user").child("user101").setValue(["email": "test2222@gmail.com", "friends": ["user01", "user02", "user03"], "name": "John Doe"])
        
        let key = ref.child("article").childByAutoId().key
        let post = ["content": "我想回家",
                    "posted_by": "user01",
                    "tag": "beauty"]
        
        let childUpdates = ["/article/\(key)": post]
        
        ref.updateChildValues(childUpdates)
        
        ref.observe(.value) { (snapshot) in
            print(snapshot)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

