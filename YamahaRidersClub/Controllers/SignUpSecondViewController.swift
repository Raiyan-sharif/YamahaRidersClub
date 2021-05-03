//
//  SignUpSecondViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 2/5/21.
//

import UIKit

class SignUpSecondViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var districtPicker: UIPickerView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nidTF: UITextField!
    @IBOutlet weak var drivingLCTF: UITextField!
    
    let genderList = ["Male", "Female"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1{
            return 1
        }
        else if pickerView.tag == 2{
            return 1
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return VerificationResponseModel.districtList.count
        }
        else if pickerView.tag == 2{
            return genderList.count
        }
        
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        print(component)
        if pickerView.tag == 1{
            VerificationResponseModel.districtCode = VerificationResponseModel.districtList[row].districtCode
            print("District Code \(VerificationResponseModel.districtCode)")
        }
        else if pickerView.tag == 2{
            VerificationResponseModel.sEx = row == 1 ? "F" : "M"
            print("Gender \(VerificationResponseModel.sEx)")
        }
        
        print("May be Other")
        
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
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1){
//            VerificationResponseModel.selectedModel[1] = pickerData[row]
//            print(VerificationResponseModel.selectedModel[0])
            return VerificationResponseModel.districtList[row].districtName
        }
        else if(pickerView.tag == 2){
            return genderList[row]
        }
      
        
        return ""
    }
    
    @IBAction func datePickerSelectionAction(_ sender: Any) {
        let dateFormatter = DateFormatter()

            
        
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        

            let strDate = dateFormatter.string(from: dateOfBirthPicker.date)
        VerificationResponseModel.dateOfBirth = strDate
        print(strDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        districtPicker.dataSource = self
        districtPicker.delegate = self
        
        nameTF.delegate = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        emailTF.delegate = self
        nidTF.delegate = self
        drivingLCTF.delegate = self
        dateOfBirthPicker.datePickerMode = UIDatePicker.Mode.date
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        VerificationResponseModel.name = nameTF.text ?? ""
        VerificationResponseModel.email = emailTF.text ?? ""
        VerificationResponseModel.nid = nidTF.text ?? ""
        VerificationResponseModel.drivingLicense = drivingLCTF.text ?? ""
        //SignupThirdViewController
        gotoPage()
    }
    func gotoPage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupThirdViewController" ) as! SignupThirdViewController
        self.navigationController?.pushViewController(vc,
        animated: true)
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
