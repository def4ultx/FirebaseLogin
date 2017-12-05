//
//  SignUpViewController.swift
//  FirebaseLogin
//
//  Created by bally on 11/23/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longtitudeText: UITextField!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.roundConner(item: usernameLabel)
        self.roundConner(item: passwordLabel)
        self.roundConner(item: latitudeLabel)
        self.roundConner(item: longtitudeLabel)
        self.roundConner(item: randomButton)
        self.roundConner(item: addUserButton)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func roundConner(item: Any) {
        (item as AnyObject).layer.masksToBounds = true
        (item as AnyObject).layer.cornerRadius = 5
    }

    @IBAction func randomLatLong(_ sender: Any) {
        let latitude = (Double(arc4random_uniform(170000000))/1000000)-85.000000
        let longtitude = (Double(arc4random_uniform(360000000))/1000000)-180.000000
        latitudeText.text = String(latitude)
        longtitudeText.text = String(longtitude)
    }
    
    @IBAction func signUpMethod(_ sender: Any) {
        let isFieldEmpty = (usernameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! || (latitudeText.text?.isEmpty)! || (longtitudeText.text?.isEmpty)!
        if (isFieldEmpty) {
            showAlert(title: "Text field empty", message: "Please insert text", upload: false)
        } else {
            ref.child("user-list").observe(DataEventType.value, with: { (snapshot) in
                var canUpload: Bool = true
                if snapshot.exists() {
                    let allKey = (snapshot.value as! NSDictionary).allKeys as! [String]
                    canUpload = allKey.contains(self.usernameText.text!) ? false : true
                }
                if (canUpload) {
                    self.uploadUserData()
                    self.showAlert(title: "Register", message: "Register successful.",upload: canUpload)
                } else {
                    self.showAlert(title: "Register", message: "Username is already used.", upload: canUpload)
                }
            })
        }
    }

    func uploadUserData() {
        let key = ref.child("users").childByAutoId().key
        let post = ["username": usernameText.text!,
                    "password": passwordText.text!,
                    "latitude": Double(latitudeText.text!)!,
                    "longtitude": Double(longtitudeText.text!)!] as [String : Any]
        let childUpdates = ["/users/\(key)": post,
                            "/user-list/\(usernameText.text!)": key] as [String : Any]
        ref.updateChildValues(childUpdates)
    }
    
    func showAlert(title: String, message: String, upload: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            if (upload) {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            self.randomLatLong(self)
        }
    }
}
