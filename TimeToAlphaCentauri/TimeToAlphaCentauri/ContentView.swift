//
//  ContentView.swift
//  TimeToAlphaCentauri
//
//  Created by KOT on 5/13/20.
//  Copyright © 2020 KOT. All rights reserved.
//

import SwiftUI

enum DivisionError: Error {
    case zeroDivisor
}

extension DivisionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .zeroDivisor:
                return "Division by zero is quite problematic. " +
            "(https://en.wikipedia.org/wiki/Division_by_zero)"
        }
    }
}

struct ContentView: View {

    @State private var speedEntry = ""
    @State private var timeUnit = "second"
    @State private var resultsTimeUnit = "seconds"
    @State private var distanceUnit = "meter"
    @State private var mood = "happy"
    //@State private var distanceValue = 0.0

    let c = 3e8 //meters per second
    let alphaCentauriDistance: Double = 41_315_314_000_000_000 // distance in meters
    let timeUnits: [String:Double] = ["second":1, "hour":3600, "day":86400, "year":31_536_000]
    let resultTimeUnits: [String:Double] = ["seconds":1, "hours":3600, "days":86400, "years":31_536_000]
    let distanceUnits: [String:Double] = ["meter":1, "kilometer":1000]

    func divide(_ x: Double, by y: Double) throws -> Double {
        guard y != 0 else {
            throw DivisionError.zeroDivisor
        }
        return Double(x / y)
    }

    var speed: Double {
        let distanceAdjust = distanceUnits[distanceUnit] ?? 0
        let divisor = timeUnits[timeUnit] ?? 0
        let resultsTimeAdjust = resultTimeUnits[resultsTimeUnit] ?? 0
        let numerator = distanceAdjust * resultsTimeAdjust
        var tempresult = 0.0
        do {
            tempresult = try divide(numerator, by: divisor)
            print(tempresult)
        }
        catch let error as DivisionError {
            print("Division error handler block")
            print(error.localizedDescription)
        }
        catch {
            print("Generic error handler block")
            print(error.localizedDescription)
        }
        return tempresult
    }

    var speedAdjust: Double {
        let rawSpeed = Double(speedEntry) ?? 0
        return rawSpeed
    }

    var timeResult: Double {
        var tempresult = 0.0
        let divisor = speed * speedAdjust
        let numerator = alphaCentauriDistance
        do {
            tempresult = try divide(numerator, by: divisor)
        }
        catch let error as DivisionError {
            print("Division error handler block")
            print(error.localizedDescription)
        }
        catch {
            print("Generic error handler block")
            print(error.localizedDescription)
        }
        return tempresult
    }

    var body: some View {
        NavigationView {
            Form {
                Spacer()
                VStack(alignment: .center) {
                    TextField("Enter speed...", text: $speedEntry)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

                    Text("Select units of distance and time:")
                        .font(.callout)
                        .bold()
                    Picker("Distance Unit", selection: $distanceUnit)  {
                        ForEach(distanceUnits.sorted(by: {$0.value < $1.value}), id: \.key) { key, value in
                            Text("\(key)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text(" - per -")
                        .font(.callout)
                        .bold()
                    Picker("Time Unit", selection: $timeUnit) {
                        ForEach(timeUnits.sorted(by: {$0.value < $1.value}), id: \.key) { key, value in
                            Text("\(key)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())

                    Spacer()
                    Spacer()
                    Spacer()

                    Text("Expected travel time:")
                    if speedEntry == "" {
                        Text("waiting for input")
                            .foregroundColor(Color.red)
                    } else {
                        if timeResult < 1 {
                            Text("\(timeResult, specifier: "%.8f")")
                        } else if timeResult < 100 {
                            Text("\(timeResult, specifier: "%.2f")")
                        } else {
                            Text("\(timeResult, specifier: "%.0f")")
                        }
                        HStack {
                            Picker("Time Unit", selection: $resultsTimeUnit) {
                                ForEach(resultTimeUnits.sorted(by: {$0.value < $1.value}), id: \.key) { key, value in
                                    Text("\(key)")
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                    }
                }

            .navigationBarTitle("Time to \u{03B1} Centauri?")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
