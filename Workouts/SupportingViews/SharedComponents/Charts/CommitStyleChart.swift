//
//  CommitStyleChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/2/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

func getColor(count: Int) -> UIColor {
    switch count {
    case -1:
        return .systemBackground
    case 0:
        return .secondarySystemBackground
    case 1:
        return UIColor(named: "Green_1")!
    case 2:
        return UIColor(named: "Green_2")!
    case 3:
        return UIColor(named: "Green_3")!
    default:
        return UIColor(named: "Green_4")!
    }
}
func getDimension(geometryWidth: CGFloat, numWeeks: Double) -> CGFloat {
    width = geometryWidth
    let spacing = CGFloat(numWeeks * 2)
    let padding: CGFloat = 10
    let value = (CGFloat(geometryWidth - spacing - padding)/CGFloat(numWeeks))
    return value
}
var width: CGFloat = 0
struct ChartHorizontalRow: View {
    var data = [Int]()
    var size: CGFloat
    
    var body: some View {
        return GeometryReader { geometry in
            HStack(spacing: 3) {
                ForEach(0..<self.data.count, id: \.self) { item in
                    Rectangle()
                        .frame(width: self.size, height: self.size, alignment: .center)
                        .foregroundColor(Color(getColor(count: self.data[item])))
                        .padding(0)
                }
            }
        }.frame(width: self.size, height: self.size, alignment: .leading)
    }
}

struct CommitStyleChart: View {
    @State var groupedWorkouts: [Date: [HKWorkout]]?
    var numMonthsBack: Int = 6
    
    var body: some View {
        var months = [String]()
        let weekdays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]
        
        var dateWorkoutsDict = [Date: Int]()

        var startDate = Calendar.current.date(byAdding: .month, value: -numMonthsBack, to: Date())!
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "EEE"

        let weekDayOfStartDate = weekFormatter.string(from: startDate)
        let numDaysToAdd = weekdays.firstIndex(of: weekDayOfStartDate)
        let timeInt = Double(numDaysToAdd ?? 0)
        startDate = startDate.advanced(by: -timeInt)
        startDate = Calendar.current.date(byAdding: .day, value: -(numDaysToAdd ?? 0 + 1), to: startDate)!
        
        HealthKitAssistant.getNumWorkoutsPerDay(numMonthsBack: numMonthsBack, plusDays: numDaysToAdd ?? 0) { results, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.groupedWorkouts = results
        }
        
        if let value = self.groupedWorkouts?.filter({ $0.key.day == startDate.day && $0.key.month == startDate.month }).first {
            dateWorkoutsDict[value.key] = value.value.count
        }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"

        while startDate < endDate {
            if !months.contains(monthFormatter.string(from: startDate)) {
                months.append(monthFormatter.string(from: startDate))
            }
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            if let value = self.groupedWorkouts?.filter({ $0.key.day == startDate.day && $0.key.month == startDate.month }).first {
                dateWorkoutsDict[value.key] = value.value.count
            } else {
                dateWorkoutsDict[startDate] = 0
            }
        }
        
        let sortedDates = dateWorkoutsDict.sorted { $0.key < $1.key }

        let sundays = sortedDates.filter { $0.key.weekday == "Sunday" }.map { $0.value }
        let mondays = sortedDates.filter { $0.key.weekday == "Monday" }.map { $0.value }
        let tuesdays = sortedDates.filter { $0.key.weekday == "Tuesday" }.map { $0.value }
        let wednesdays = sortedDates.filter { $0.key.weekday == "Wednesday" }.map { $0.value }
        let thursdays = sortedDates.filter { $0.key.weekday == "Thursday" }.map { $0.value }
        let fridays = sortedDates.filter { $0.key.weekday == "Friday" }.map { $0.value }
        let saturdays = sortedDates.filter { $0.key.weekday == "Saturday" }.map { $0.value }
        
        var rowsOfWeekdays = [
            sundays,
            mondays,
            tuesdays,
            wednesdays,
            thursdays,
            fridays,
            saturdays
        ]
        
        // we need to iterate through and find which index has the max elements, all of the items BEFORE this, need to have one appended before until they reach the max, all after have to have items appended at the end
        var maxCount = 0
        var indexOfMaxCount = 0
        for i in 0..<rowsOfWeekdays.count {
            if rowsOfWeekdays[i].count > maxCount {
                maxCount = rowsOfWeekdays[i].count
                indexOfMaxCount = i
            }
        }
        for i in 0..<rowsOfWeekdays.count {
            if rowsOfWeekdays[i].count < maxCount && i < indexOfMaxCount {
                while rowsOfWeekdays[i].count != maxCount {
                    rowsOfWeekdays[i].insert(-1, at: 0)
                }
            } else if rowsOfWeekdays[i].count < maxCount && i > indexOfMaxCount {
                while rowsOfWeekdays[i].count != maxCount {
                    rowsOfWeekdays[i].append(-1)
                }
            }
        }

        return VStack(alignment: .leading) {
            Text("Overview of the past \(numMonthsBack) months.")
                .fontWeight(.semibold)
                .font(.headline)
                .padding()
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .bottom) {
                ForEach(months, id: \.self) { month in
                    HStack {
                        Spacer()
                        Text(month)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
            }.frame(width: width - 20).padding(.leading, 45)
            HStack {
                Spacer()
                // Weekday y axis
                //
                VStack(alignment: .trailing, spacing: 3) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 5)
                            .frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)))
                    }
                }.frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)) * 7)
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 3) {
                        // Chart Body
                        //
                        ForEach(rowsOfWeekdays, id: \.self) { row in
                            ChartHorizontalRow(data: row, size: getDimension(geometryWidth: geometry.size.width, numWeeks: Double(maxCount)))
                                .padding(0)
                        }
                    }.frame(height: getDimension(geometryWidth: geometry.size.width, numWeeks: Double(maxCount)) * 7 + 5)
                }
                Spacer()
                Spacer()
            }.frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)) * 7 + 5)
            HStack(spacing: 2) {
                Text("Number of Workouts Per Day")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)))
                Spacer()
                Text("0")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.trailing, 5)
                    .frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)))
                Rectangle()
                    .frame(width: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), alignment: .center)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .padding(0)
                Rectangle()
                    .frame(width: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), alignment: .center)
                    .foregroundColor(Color(UIColor(named: "Green_1")!))
                    .padding(0)
                Rectangle()
                    .frame(width: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), alignment: .center)
                    .foregroundColor(Color(UIColor(named: "Green_2")!))
                    .padding(0)
                Rectangle()
                    .frame(width: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), alignment: .center)
                    .foregroundColor(Color(UIColor(named: "Green_3")!))
                    .padding(0)
                Rectangle()
                    .frame(width: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)), alignment: .center)
                    .foregroundColor(Color(UIColor(named: "Green_4")!))
                    .padding(0)
                Text("4+")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.trailing, 5)
                    .frame(height: getDimension(geometryWidth: width, numWeeks: Double(maxCount)))
            }.padding()
        }
    }
}

struct CommitStyleChart_Previews: PreviewProvider {
    static var previews: some View {
        CommitStyleChart()
    }
}
