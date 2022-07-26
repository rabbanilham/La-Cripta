//
//  String+Extension.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import Foundation

extension String {
    func convertToDateInterval() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let finalDate = calendar.date(from: components)!
        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.maximumUnitCount = 1
        intervalFormatter.unitsStyle = .full
        intervalFormatter.zeroFormattingBehavior = .dropAll
        intervalFormatter.allowedUnits = [.day, .hour, .minute, .second]
        guard let finalString = intervalFormatter.string(from: finalDate, to: Date()) else { return self }
        return finalString
    }
}
