//
//  OTPVerificationViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 1/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class OTPVerificationViewController: UIViewController {
    var userDefaults = UserDefaults.standard
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resendLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNoTF.layer.borderWidth = 2.0
        mobileNoTF.layer.cornerRadius = 14.0
        mobileNoTF.layer.borderColor = #colorLiteral(red: 0.1794194281, green: 0.06704645604, blue: 0.6007958055, alpha: 1)
        
        
        submitBtn.layer.borderWidth = 2.0
        submitBtn.layer.cornerRadius = 14.0
        submitBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        let tap = UITapGestureRecognizer(target: self, action: #selector(OTPVerificationViewController.resendTextFieldPressed))
        resendLabel.isUserInteractionEnabled = true
        resendLabel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        if userDefaults.string(forKey: "mobileno") != nil{
            print(userDefaults.string(forKey: "mobileno") ?? "")
        }
    }
    

    @IBAction func verifyButtomPressed(_ sender: Any) {
        let mobNo = userDefaults.string(forKey: "mobileno") ?? ""
        let otp = mobileNoTF.text ?? ""
        if mobNo != ""{
            if(otp == ""){
                let alert = UIAlertController(title: "Error", message: "OTP Should be of 6 Digits", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if (otp.count != 6){
                let alert = UIAlertController(title: "Error", message: "OTP Should be of 6 Digits", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            else{
                self.verifyOTP(mobileNo: mobNo, oTP: otp)
            }
        }
    }
    
    @objc
    func resendTextFieldPressed(sender:UITapGestureRecognizer) {
        
        //PhoneVerificationViewController
        if userDefaults.string(forKey: "mobileno") != nil{
            print(userDefaults.string(forKey: "mobileno") ?? "")
            let mobNo = userDefaults.string(forKey: "mobileno") ?? ""
            generateOTP(mobileNo: mobNo)
            
        }
        
       
    }
    
    func generateOTP(mobileNo:String){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        AF.request("http://apps.acibd.com/apps/yrc/riderinfo/otpgeneration?mobileno=\(mobileNo)").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["success"]==1){
                        self.userDefaults.setValue(mobileNo, forKey: "mobileno")
                        self.dismiss(animated: false, completion: nil)
                    }
                }
                
            }
        }
    }
    
    
    func verifyOTP(mobileNo:String, oTP:String){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        AF.request("http://apps.acibd.com/apps/yrc/riderinfo/otpconfirmation?mobileno=\(mobileNo)&sixdigitnumber=\(oTP)").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["success"]==1){
                        self.userDefaults.setValue(mobileNo, forKey: "mobileno")
                        self.dismiss(animated: false, completion: nil)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController" ) as! SignUpViewController
                        self.navigationController?.pushViewController(vc,
                        animated: true)
                        
                    }
                    
                    
                    
                    
                   
                }
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
