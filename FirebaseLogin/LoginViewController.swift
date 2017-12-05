//
//  LoginViewController
//  FirebaseLogin
//
//  Created by bally on 11/23/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        self.roundConner(item: usernameLabel)
        self.roundConner(item: passwordLabel)
        self.roundConner(item: usernameText)
        self.roundConner(item: passwordText)
        self.roundConner(item: signInButton)
        self.roundConner(item: cancelButton)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInMethod(_ sender: Any) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) { return }
            var userKey: String!
            var userData: NSDictionary!
            let keyList = (snapshot.value as! NSDictionary).value(forKey: "user-list") as! NSDictionary
            if keyList[self.usernameText.text!] != nil {
                userKey = keyList.value(forKey: self.usernameText.text!) as! String
            } else {
                self.showToast(message: "Login failed.")
                return
            }
            let dataList = (snapshot.value as! NSDictionary).value(forKey: "users") as! NSDictionary
            if dataList[userKey] != nil {
                userData = dataList.value(forKey: userKey) as! NSDictionary
            } else {
                self.showToast(message: "Login failed.")
                return
            }
            if ((userData.value(forKey: "username") as! String) == self.usernameText.text && (userData.value(forKey: "password") as! String) == self.passwordText.text) {
                self.showToast(message: "Login Success.")
                sleep(1)
                self.performSegue(withIdentifier: "goToMainPage", sender: self)
            } else {
                self.showToast(message: "Login failed.")
                return
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cancelMethod(_ sender: Any) {
        self.usernameText.text = ""
        self.passwordText.text = ""
    }
    
    private func roundConner(item: Any) {
        (item as AnyObject).layer.masksToBounds = true
        (item as AnyObject).layer.cornerRadius = 5
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
