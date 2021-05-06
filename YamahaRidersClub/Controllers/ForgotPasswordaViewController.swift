//
//  ForgotPasswordaViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 6/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPasswordaViewController: UIViewController {

    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var sendMyPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mobileNoTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mobileNoTF.layer.borderWidth = 2.0
        mobileNoTF.layer.cornerRadius = 14.0
        mobileNoTF.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        sendMyPasswordBtn.layer.borderWidth = 2.0
        sendMyPasswordBtn.layer.cornerRadius = 14.0
        sendMyPasswordBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    

    @IBAction func sendMyPasswordPressed(_ sender: UIButton) {
        
        var userInputMobileNo = mobileNoTF.text ?? ""
        
        
        if(userInputMobileNo == ""){
            let alert = UIAlertController(title: "Error", message: "Moblie Number Should be of 11 Digits", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (userInputMobileNo.count != 11){
            let alert = UIAlertController(title: "Error", message: "Moblie Number Should be of 11 Digits", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            getNewPassword()
        }
        
        
    }
    func getNewPassword(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        
        AF.request("http://apps.acibd.com/apps/yrc/riderinfo/forgetpassword?mobileno=\(mobileNoTF.text ?? "")").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)

                    if(swiftyJsonVar["success"].int == 1){
                        self.dismiss(animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        
                        

                      
                    }
                    else{
                        self.dismiss(animated: true, completion:nil)
                        let alert = UIAlertController(title: "Error", message: "This Number was not Registered", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                    }
                }
                
            }
        }
    }
    

}
