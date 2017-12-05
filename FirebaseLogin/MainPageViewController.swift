//
//  MainPageViewController.swift
//  FirebaseLogin
//
//  Created by bally on 11/24/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var userList = [User]()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.ref = Database.database().reference()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainPageViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.loadAllUserData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let destination = segue.destination as! MapViewController
            destination.userData = userList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        tableCell.textLabel?.text = userList[indexPath.row].Username
        return tableCell
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Logout", message: "Would you like to Logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadAllUserData() {
        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
//            let jsonData = snapshot.value as! NSDictionary
//            let userKey = snapshot.key as! String
            for child in snapshot.children {
                let childData = (child as! DataSnapshot).value as! NSDictionary
                let username = childData.value(forKey: "username") as! String
                let password = childData.value(forKey: "password") as! String
                let latitude = childData.value(forKey: "latitude") as! Double
                let longtitude = childData.value(forKey: "longtitude") as! Double
                self.userList.append(User(user: username, pass: password, lat: latitude, long: longtitude))
            }
            self.tableView.reloadData()
        })
    }
}
