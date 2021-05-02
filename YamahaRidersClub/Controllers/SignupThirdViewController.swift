//
//  SignupThirdViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 2/5/21.
//

import UIKit

class SignupThirdViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 1){
            return VerificationResponseModel.occupationList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    

    @IBOutlet weak var occupationPicker: UIPickerView!
    @IBOutlet weak var maritalStatusPicker: UIPickerView!
    @IBOutlet weak var presentAddressPicker: UIPickerView!
    @IBOutlet weak var permenetAddressPicker: UIPickerView!
    @IBOutlet weak var presentAddressTF: UITextField!
    @IBOutlet weak var permenantAddressTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        occupationPicker.dataSource = self
        occupationPicker.delegate = self
        maritalStatusPicker.dataSource = self
        maritalStatusPicker.delegate = self
        presentAddressPicker.delegate = self
        presentAddressPicker.dataSource = self
        permenetAddressPicker.delegate = self
        permenetAddressPicker.dataSource = self
        presentAddressTF.delegate = self
        permenantAddressTF.delegate = self
        

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
     if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
     nextField.becomeFirstResponder()
     } else {
     textField.resignFirstResponder()
     }
     return false
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
