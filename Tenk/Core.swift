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
    
    init() {
        requestHKAuthorization()
        fetchStepCountData()
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
    
    