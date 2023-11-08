//
//  ContentView.swift
//  Tenk
//
//  Created by Charel Felten on 08/11/2023.
//

import SwiftUI
import HealthKit
import Charts

struct ContentView: View {
  
  @State var stepcount: Double = 0
  @State var stepcounts: [Date:Double] = [:]
  
  func requestHealthKitAuthorization() {
    let healthStore = HKHealthStore()
    if HKHealthStore.isHealthDataAvailable() {
      let readTypes: Set<HKObjectType> = [HKSampleType.quantityType(forIdentifier: .stepCount)!]
      healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
        if success {
          print("success", success, error)
          // Authorization granted, you can now fetch step count data.
        } else {
          print("failure", success, error)
          // Handle the error or inform the user that access was denied.
        }
      }
    }
  }
  
  func fetchStepCount() {
      let healthStore = HKHealthStore()
      guard let stepCountType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
          // Step count data type is not available
          return
      }
      let calendar = Calendar.current
      let now = Date()
      let startOfDay = calendar.startOfDay(for: now)
      let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
      let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum,
                                              anchorDate: startOfDay,
                                              intervalComponents: DateComponents(day: 1))
      
      query.initialResultsHandler = { query, results, error in
          if let statistics = results, let sum = statistics.statistics().first?.sumQuantity() {
            stepcount = sum.doubleValue(for: HKUnit.count())
              // Use the stepCount in your SwiftUI view
          }
      }
      
      healthStore.execute(query)
  }
  

  func fetchGranularStepCountData() {
      let healthStore = HKHealthStore()
      
      // Check if step count data is available
      if HKHealthStore.isHealthDataAvailable() {
          let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
          
          // Create a predicate to specify the time range you're interested in
          let startDate = Calendar.current.startOfDay(for: Date()) // Start of the current day
          let endDate = Date() // End of the current day (or any other end date you prefer)
          let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
          
          // Create a query to fetch step count data
          let query = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
              if let samples = results as? [HKQuantitySample] {
                var acc: Double = 0
                stepcounts[startDate] = acc
                  for sample in samples {
                      let quantity = sample.quantity
                      let count = quantity.doubleValue(for: HKUnit.count())
                      let date = sample.startDate
                      acc += count
                      stepcounts[date] = acc
                  }
              } else {
                  if let error = error {
                      // Handle the error
                      print("Error fetching step count data: \(error)")
                  }
              }
          }
          
          healthStore.execute(query)
      }
  }


  
  
  
  var body: some View {
          VStack(spacing: 20) {
              Button("Request HealthKit Authorization") {
                  requestHealthKitAuthorization()
              }
              Button("Fetch Step Count") {
                  fetchStepCount()
              }
            Button("Fetch Step Count") {
              fetchGranularStepCountData()
            }
            Text(String(describing: stepcount))
//            Text(String(describing: stepcounts))
            Chart {
                ForEach(stepcounts.sorted(by: >), id: \.key) { key, value in
                    LineMark(
                        x: .value("Index", key),
                        y: .value("Value", value)
                    )
                }
            }
              }
      }
}

#Preview {
  ContentView()
}
