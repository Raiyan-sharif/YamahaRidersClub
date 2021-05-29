//
//  ViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 11/3/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    var userInputMobileNo: String = ""
    var userInputPassword:String = ""
    
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var errorMessagelebel: UILabel!
    
    var userManager = LoginManager()
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        userManager.delegate = self
        //01755939896
        //1234
        
        mobileNoTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mobileNoTF.layer.borderWidth = 2.0
        mobileNoTF.layer.cornerRadius = 14.0
        mobileNoTF.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        passwordTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTF.layer.borderWidth = 2.0
        passwordTF.layer.cornerRadius = 14.0
        passwordTF.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        mobileNoTF.delegate = self
        passwordTF.delegate = self
        
        signUpLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        loginBtn.layer.borderWidth = 2.0
        loginBtn.layer.cornerRadius = 14.0
        loginBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        forgetPasswordLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1647058824, green: 0.07450980392, blue: 0.5764705882, alpha: 1)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.signUpTapped))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tap)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.forgotPasswordTapped))
        forgetPasswordLabel.isUserInteractionEnabled = true
        forgetPasswordLabel.addGestureRecognizer(tap2)
        goToHomePage()
        // Do any additional setup after loading the view.
    }
    func goToHomePage(){
        let loginStatus = userDefaults.bool(forKey: "isloggedIn")
        if userDefaults.string(forKey: "mobileno") != nil && loginStatus == true{
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            let testVc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
             
             navigationController?.pushViewController(vc,
             animated: false)
//            guard let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") else {return}
//            
//        
//            present(homeViewController, animated: false)
            
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        //PhoneVerificationViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationViewController") as! PhoneVerificationViewController
//            let testVc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
         
         navigationController?.pushViewController(vc,
         animated: false)
    }
    
    @objc
    func forgotPasswordTapped(sender:UITapGestureRecognizer) {
        //ForgotPasswordaViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordaViewController") as! ForgotPasswordaViewController
//            let testVc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
         
         navigationController?.pushViewController(vc,
         animated: false)
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
                self.userDefaults.setValue(true, forKey: "isloggedIn")
                self.userDefaults.setValue(user.mobileno, forKey: "mobileno")
                self.userDefaults.setValue(self.userInputPassword, forKey: "password")
                self.goToHomePage()
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



