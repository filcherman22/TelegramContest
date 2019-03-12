//
//  ParseJson.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 12.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}

class ParseJson {
    
    var arrPoints: [DayInfo] = []
    var arrGraph: [GraphInfo] = []
    
    init() {
        parseJson()
    }
    
    private func parseJson() {
        do{
            let file = Bundle.main.path(forResource: "chart_data", ofType: "json")
            let data = try Data(contentsOf: URL(fileURLWithPath: file!))
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
            for el in jsonData!{
                var nameX: String = "x"
                var arrLineNames: [String] = []
                var arrDayInfo: [DayInfoUni] = []
                var arrColors: [UIColor] = []
                let graph = el as! [String: AnyObject]
                let columns = graph["columns"] as! [NSArray]
                // names / colors
                let names = graph["names"] as! [String: String]
                let colors = graph["colors"] as! [String: String]
                for col in columns{
                    let c = col[0] as! String
                    if c != "x"{
                        arrLineNames.append(names[c]!)
                        let color = UIColor(hexString: colors[c]!)
                        arrColors.append(color!)
                    }
                }
                //values
                let count = columns.count
                let countValue = columns[0].count
                for i in 1...countValue - 1{
                    var arrValue: [Int] = []
                    for n in 1...count - 1{
                        let value = columns[n][i] as! Int
                        arrValue.append(value)
                    }
                    arrDayInfo.append(DayInfoUni(dateInt: columns[0][i] as! Int, arrYValue: arrValue))
                }
                self.arrGraph.append(GraphInfo(arrDayInfo: arrDayInfo, arrLineName: arrLineNames, arrLineColor: arrColors, nameX: nameX))
                
            }
        }
        catch let error{
            print(error)
        }
        
    }
    
    func getArrPoint() -> [GraphInfo]{
        return arrGraph
    }
}
