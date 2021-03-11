//
//  loginModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 12/3/21.
//

import Foundation

struct LoginModel: Codable {
    let success: Int
    let message: String
    let name, age, sex: String?
    let mobileno, chessisno, engineno, registrationno: String?
    let brandcode, brandname, productcode, productname: String?
    let dealarcode, dealarname, address: String?
}
