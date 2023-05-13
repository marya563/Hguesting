//
//  Hotel.swift
//  hguesting
//
//  Created by Mac Mini 9 on 10/4/2023.
//

import Foundation

struct Hotel:Decodable{
    
    let _id:String
    let name:String
    let description:String
    let adress:String
    let price:Int
    let image:String
}
