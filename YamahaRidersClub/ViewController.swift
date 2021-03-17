//
//  ViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 11/3/21.
//

import UIKit

class ViewController: UIViewController {

    var userInputMobileNo: String = ""
    var userInputPassword:String = ""
    
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var errorMessagelebel: UILabel!
    
    var userManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        
        mobileNoTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mobileNoTF.layer.borderWidth = 2.0
        mobileNoTF.layer.cornerRadius = 14.0
        mobileNoTF.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        passwordTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTF.layer.borderWidth = 2.0
        passwordTF.layer.cornerRadius = 14.0
        passwordTF.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        signUpLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        loginBtn.layer.borderWidth = 2.0
        loginBtn.layer.cornerRadius = 14.0
        loginBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        forgetPasswordLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.signUpTapped))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tap)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.forgotPasswordTapped))
        forgetPasswordLabel.isUserInteractionEnabled = true
        forgetPasswordLabel.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        userInputMobileNo = mobileNoTF.text ?? ""
        userInputPassword = passwordTF.text ?? ""
        
        if(userInputMobileNo == "" || userInputPassword == ""){
            errorMessagelebel.text = "Mobile No or Password Missing"
            errorMessagelebel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else if (userInputMobileNo.count != 11){
            errorMessagelebel.text = "Mobile number should be 11 digit"
        }
        else{
            userManager.fetchUser(mobileno: userInputMobileNo, password: userInputPassword)
        }
        
    }
    
    @objc
    func signUpTapped(sender:UITapGestureRecognizer) {
        print("Sign up Page")
    }
    
    @objc
    func forgotPasswordTapped(sender:UITapGestureRecognizer) {
        print("Forgot Password")
    }
    


}

extension ViewController: LoginManagerDelegate{
    func didLogin(_ userManager: LoginManager, user: LoginModel) {
        DispatchQueue.main.async {
            if user.success == 0{
                self.errorMessagelebel.text = user.message
                self.errorMessagelebel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            else{
                self.errorMessagelebel.text = "Correct"
                self.errorMessagelebel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.errorMessagelebel.text = "incorrect"
            self.errorMessagelebel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    
}

