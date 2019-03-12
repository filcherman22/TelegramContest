//
//  DayInfo.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 12.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import Foundation

struct DayInfo {
    init(dateInt: Int, y0: Int, y1: Int) {
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        self.y0 = y0
        self.y1 = y1
    }
    let date: Date!
    let y0: Int!
    let y1: Int!
}


struct DayInfoUni {
    init(dateInt: Int, arrYValue: [Int]) {
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        for el in arrYValue{
            arrY.append(el)
        }
    }
    let date: Date!
    var arrY: [Int] = []
}
