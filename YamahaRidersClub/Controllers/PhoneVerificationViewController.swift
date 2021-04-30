//
//  PhoneVerificationViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 30/4/21.
//

import UIKit

class PhoneVerificationViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mobileNoTF.layer.borderWidth = 2.0
        mobileNoTF.layer.cornerRadius = 14.0
        mobileNoTF.layer.borderColor = #colorLiteral(red: 0.1794194281, green: 0.06704645604, blue: 0.6007958055, alpha: 1)
        
        
        submitBtn.layer.borderWidth = 2.0
        submitBtn.layer.cornerRadius = 14.0
        submitBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if(mobileNoTF.text == ""){
            let alert = UIAlertController(title: "Error", message: "Moblie Number Should be of 11 Digits", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (mobileNoTF.text?.count != 11){
            let alert = UIAlertController(title: "Error", message: "Moblie Number Should be of 11 Digits", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else{
            
        }
        
    }
}
