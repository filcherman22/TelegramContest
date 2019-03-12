//
//  DecodeStructs.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 12.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import Foundation

struct ArrData: Decodable {
//    var graphs: [GraphData]?
}

//struct GraphData: Decodable {
//    var colors: Colors?
//    var columns: Columns?
//    var names: Names?
//    var types: Types?
//}
struct Columns: Decodable {
    var xData: [Date]?
    var y0Data: [Date]?
    var y1Data: [Date]?
}

struct Types: Decodable {
    var y0Type: String?
    var y1Type: String?
    var xType: String?
}

struct Names: Decodable {
    var y0Name: String?
    var y1Name: String?
}

struct Colors: Decodable {
    var y0Color: String?
    var y1Color: String?
}
