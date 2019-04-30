//
//  FactData.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation

//Model struct for Facts
struct FactData: Decodable {
    var title: String?
    var rows: [Fact]?
}
//Model struct for the individual fact data
struct Fact: Decodable {
    var title: String?
    var description: String?
    var imageHref: String?
}
