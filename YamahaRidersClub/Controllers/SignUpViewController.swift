//
//  SignUpViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 1/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    var modelSelectedCode:String = ""
    @IBOutlet weak var engineTF: UITextField!
    @IBOutlet weak var chesisTF: UITextField!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return VerificationResponseModel.brandlistArray.count
        }
        
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        print(component)
        if(component == 1){
            VerificationResponseModel.productCode = pickerDataCode[row]
        }
        else{
            VerificationResponseModel.brandCode = VerificationResponseModel.brandlistArray[row].brandCode
            
        }
        print(VerificationResponseModel.brandCode)
        print(VerificationResponseModel.productCode)
        
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
        
        if(component == 1){
//            VerificationResponseModel.selectedModel[1] = pickerData[row]
//            print(VerificationResponseModel.selectedModel[0])
            return pickerData[row]
        }
        else if(component == 0){
            modelSelectedCode = VerificationResponseModel.brandlistArray[row].brandCode
            pickerData = []
            pickerDataCode = []
            for i in 0 ... VerificationResponseModel.productlistArray.count-1{
                if VerificationResponseModel.productlistArray[i].brandCode == modelSelectedCode{
                    pickerData.append(VerificationResponseModel.productlistArray[i].productName)
                    pickerDataCode.append(VerificationResponseModel.productlistArray[i].productCode)
                }
            }
//            VerificationResponseModel.selectedModel[0] = VerificationResponseModel.brandlistArray[row].brandName
//            print(VerificationResponseModel.selectedModel[0])
            pickerView.reloadComponent(1)
            return VerificationResponseModel.brandlistArray[row].brandName
        }
        
        return VerificationResponseModel.brandlistArray[row].brandName
    }
    

    @IBOutlet weak var modelSelectPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var pickerDataCode: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modelSelectPicker.delegate = self
        self.modelSelectPicker.dataSource = self
        engineTF.delegate = self
        chesisTF.delegate = self
      
        pickerData = []
        pickerDataCode = []
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func NextbtnPressed(_ sender: UIButton) {
        generateOTP()
        
    }
    func generateOTP(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        VerificationResponseModel.engineNo = engineTF.text ?? ""
        VerificationResponseModel.chasisNo = chesisTF.text ?? ""
        
        AF.request("http://apps.acibd.com/apps/yrc/syncdata/chassisvarified?engineno=\(engineTF.text ?? "")&chassisno=\(chesisTF.text ?? "")").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)

                    if(swiftyJsonVar["success"].int == 1){
                        self.dismiss(animated: true, completion: self.gotoPage)
                        
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpSecondViewController" ) as! SignUpSecondViewController
//                        self.navigationController?.pushViewController(vc,
//                        animated: true)
                      
                    }
                }
                
            }
        }
    }
    
    func gotoPage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpSecondViewController" ) as! SignUpSecondViewController
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
