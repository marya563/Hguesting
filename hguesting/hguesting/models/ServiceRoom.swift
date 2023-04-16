//
//  ServiceRoom.swift
//  hguesting
//
//  Created by Mac Mini 9 on 15/4/2023.
//

import Foundation

struct ServiceRoom:Decodable{
    
    let _id:String
    let name:String
    let description:String
    let type:String
    let price:Int
    let image:String
}
