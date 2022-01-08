//
//  String+date.swift
//  Budi
//
//  Created by 최동규 on 2021/11/10.
//

import Foundation

extension String {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "Asia/Seoul")
        return formatter
    }()

    func date() -> Date? {
        return Self.formatter.date(from: self)
    }
}

extension Date {
    
    func convertStringyyyyMMddTHHmmSS() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: self)
    }

    func convertStringyyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func convertTimePassedString() -> String {
        let date = self

        let minute = Date().distance(from: date, only: .minute)
        let hour = Date().distance(from: date, only: .hour)
        let day = Date().distance(from: date, only: .day)
        let month = Date().distance(from: date, only: .month)
        let year = Date().distance(from: date, only: .year)

        if year != 0 {
            return "\(year)년 전"
        } else if  month != 0 {
            return "\(month)개월 전"
        } else if day != 0 {
            return "\(day)일 전"
        } else if hour != 0 {
            return "\(hour)시간 전"
        } else if minute != 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}
