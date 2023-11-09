//
//  Core.swift
//  Tenk
//
//  Created by Charel Felten on 09/11/2023.
//

import Foundation
import HealthKit

struct StepQuantity {
    let date: Date
    let count: Double
}

class Core: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var steps: [StepQuantity] = []
    var HKAuthorized: Bool = false
    var HKAvailable: Bool = HKHealthStore.isHealthDataAvailable()
    
    let sample: [StepQuantity] = [
        StepQuantity(date: Date(), count: 120),
        StepQuantity(date: Date().addingTimeInterval(-3600), count: 300),
        StepQuantity(date: Date().addingTimeInterval(-7200), count: 450),
        StepQuantity(date: Date().addingTimeInterval(-10800), count: 600),
        StepQuantity(date: Date().addingTimeInterval(-14400), count: 800),
        StepQuantity(date: Date().addingTimeInterval(-18000), count: 250),
        StepQuantity(date: Date().addingTimeInterval(-21600), count: 700),
        StepQuantity(date: Date().addingTimeInterval(-25200), count: 150),
        StepQuantity(date: Date().addingTimeInterval(-28800), count: 900),
        StepQuantity(date: Date().addingTimeInterval(-32400), count: 400),
        StepQuantity(date: Date().addingTimeInterval(-36000), count: 550),
        StepQuantity(date: Date().addingTimeInterval(-39600), count: 200),
        StepQuantity(date: Date().addingTimeInterval(-43200), count: 350),
        StepQuantity(date: Date().addingTimeInterval(-46800), count: 480),
        StepQuantity(date: Date().addingTimeInterval(-50400), count: 750),
        StepQuantity(date: Date().addingTimeInterval(-54000), count: 100),
        StepQuantity(date: Date().addingTimeInterval(-57600), count: 600),
        StepQuantity(date: Date().addingTimeInterval(-61200), count: 420),
        StepQuantity(date: Date().addingTimeInterval(-64800), count: 800),
        StepQuantity(date: Date().addingTimeInterval(-68400), count: 300),
        StepQuantity(date: Date().addingTimeInterval(-72000), count: 650),
        StepQuantity(date: Date().addingTimeInterval(-75600), count: 180),
        StepQuantity(date: Date().addingTimeInterval(-79200), count: 550),
        StepQuantity(date: Date().addingTimeInterval(-82800), count: 700),
        StepQuantity(date: Date().addingTimeInterval(-86400), count: 250)
    ]
    
    init() {
        requestHKAuthorization()
        fetchStepCountData()
    }
    
    func cumulSteps() -> [StepQuantity] {
        guard self.steps.count > 0 else {return []}
        var acc: Double = 0
        var cumulSteps = [StepQuantity(
            date: Calendar.current.startOfDay(for: self.steps.first!.date),
            count: acc
        )]
        for sq in self.steps {
            cumulSteps.append(StepQuantity(date: sq.date, count: acc))
            acc += sq.count
            cumulSteps.append(StepQuantity(date: sq.date, count: acc))
        }
        return cumulSteps
    }
    
    func requestHKAuthorization() {
        guard HKAvailable else { return }
        let readTypes: Set<HKObjectType> = [
            HKSampleType.quantityType(forIdentifier: .stepCount)!
        ]
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if success {
                self.HKAuthorized = true
            } else {
                print("Error in requestHKAuthorization: \(String(describing: error))")
                self.HKAuthorized = false
            }
        }
    }

    func fetchStepCountData() {
        guard HKAvailable && HKAuthorized else { return }
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        // Create a predicate to specify the time range you're interested in
        let startDate = Calendar.current.startOfDay(for: Date()) // Start of the current day
        let endDate = Date() // Now (End of the current day)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
        // Create a query to fetch step count data
        let query = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            var steps: [StepQuantity] = []
            if let samples = results as? [HKQuantitySample] {
                for sample in samples {
                    let quantity = sample.quantity
                    let count = quantity.doubleValue(for: HKUnit.count())
                    let date = sample.startDate
                    steps.append(StepQuantity(date:date, count: count))
                }
            } else {
                if let error = error {
                    print("Error fetching step count data: \(error)")
                }
            }
            self.steps = steps
        }
        healthStore.execute(query)
    }
}
    
    
