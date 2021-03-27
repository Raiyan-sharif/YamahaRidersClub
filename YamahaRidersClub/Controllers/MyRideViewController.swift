//
//  MyRideViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import UIKit

class MyRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "My Ride History"
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
