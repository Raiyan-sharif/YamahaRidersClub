//
//  PrivacyPageViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 6/4/21.
//

import UIKit
import WebKit

class PrivacyPageViewController: UIViewController {

    @IBOutlet weak var htmlLoadingwebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(ConstantSring.privacyOption == 1){
            let htmlPath = Bundle.main.path(forResource: "open_source_licenses", ofType: "html")
            let url = URL(fileURLWithPath: htmlPath!)
            let request = URLRequest(url: url)
            htmlLoadingwebView.load(request)
        }
        else if(ConstantSring.privacyOption == 2){
            let htmlPath = Bundle.main.path(forResource: "terms_conditions", ofType: "html")
            let url = URL(fileURLWithPath: htmlPath!)
            let request = URLRequest(url: url)
            htmlLoadingwebView.load(request)
        }
        
        // Do any additional setup after loading the view.
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
