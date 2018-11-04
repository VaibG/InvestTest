//
//  BlackRockAPIHelper.swift
//  ScenarioTester
//
//  Created by Vaibhav Gattani on 2/11/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BlackRockAPIHelper {
    
    //This function will get the status for a flight. FlightNum format "LHXXX" Date format "YYYY-MM-DD"
    static func getStock(view: StockVC, portfolio: String, startDate: String, endDate: String, completion: @escaping (Stock) -> ()){
        
        //Request URL and authentication parameters
        let requestURL = "https://www.blackrock.com/tools/hackathon/portfolio-analysis?calculateExposures=true&calculatePerformance=true&includePerformanceChart=true&includePlaceholdersInPerformanceChart=true&positions=\(portfolio)"
        print(portfolio)

        Alamofire.request(requestURL).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            let json = JSON(response.result.value)
            //print(json)
            print(startDate)
            print(endDate)
            let portfolio = Stock()
            let levelOne = json["resultMap"]["PORTFOLIOS"][0]["portfolios"][0]["returns"]["returnsMap"][startDate]["level"].floatValue
            print(levelOne)
            let levelTwo = json["resultMap"]["PORTFOLIOS"][0]["portfolios"][0]["returns"]["returnsMap"][endDate]["level"].floatValue
            print(levelTwo)
            portfolio.performance = (levelTwo - levelOne)/levelOne * 100
            print(portfolio.performance)
            completion(portfolio)

        }
    }
    
        static func getGraph(view: PortfolioInfoVC, completeAll: Stock, portfolio: String, startDate: String, endDate: String, completion: @escaping (Stock) -> ()){
        
        //Request URL and authentication parameters
        let requestURL = "https://www.blackrock.com/tools/hackathon/portfolio-analysis?calculateExposures=true&calculatePerformance=true&includePerformanceChart=true&includePlaceholdersInPerformanceChart=true&positions=\(portfolio)"
        Alamofire.request(requestURL).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            let json = JSON(response.result.value)
            //print(json)
            var Points: [Point] = []
            var currDate: String = startDate
            while currDate != endDate {
                let newPoint = Point()
                newPoint.date = json["resultMap"]["PORTFOLIOS"][0]["portfolios"][0]["returns"]["returnsMap"][currDate]["asOfDate"].stringValue
                newPoint.level = json["resultMap"]["PORTFOLIOS"][0]["portfolios"][0]["returns"]["returnsMap"][currDate]["level"].stringValue
                Points.append(newPoint)
                print(newPoint.date)
                print(newPoint.level)
                
                let year = String(currDate[currDate.index(currDate.startIndex, offsetBy: 0)
                    ..< currDate.index(currDate.startIndex, offsetBy: 4)])
                let month = String(currDate[currDate.index(currDate.startIndex, offsetBy: 4)
                    ..< currDate.index(currDate.startIndex, offsetBy: 6)])
                //let day = String(currDate[currDate.index(currDate.startIndex, offsetBy: 6)
                //    ..< currDate.index(currDate.endIndex, offsetBy: 0)])
                
                if month == "12" {
                    
                    let newYear = Int(year)! + 1
                    
                    currDate = String(newYear) + "01" + "31"
                    
                } else if month == "01" {
                    
                    currDate = year + "02" + "28"
                    
                } else if ((Int(month)! % 2 == 0) && (Int(month)! < 8)) || ((Int(month)! % 2 == 1) && (Int(month)! > 7)) {
                    
                    let newMonth = Int(month)! + 1
                    
                    if newMonth < 10{
                        
                        currDate = year + "0" + String(newMonth) + "31"
                        
                    } else {
                        
                        currDate = year + String(newMonth) + "31"
                        
                    }
                    
                } else if ((Int(month)! % 2 == 1) && (Int(month)! < 8)) || ((Int(month)! % 2 == 0) && (Int(month)! > 7)){
                    
                    let newMonth = Int(month)! + 1
                    
                    if newMonth < 10 {
                        
                        currDate = year + "0" + String(newMonth) + "30"
                        
                    } else {
                        
                        currDate = year + String(newMonth) + "30"
                        
                    }
                    
                }
                
            }
            
            print("appended all points")
            completeAll.points = Points
            completion(completeAll)
            
        }
        
    }
    
    
    
}
