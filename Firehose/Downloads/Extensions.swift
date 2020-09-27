//
// Created by Jefferson Jones on 9/27/20.
// Copyright (c) 2020 Jefferson Jones. All rights reserved.
//

import Foundation

extension URLRequest {

  static func get(string: String) -> URLRequest? {
    guard let url = URL(string: string) else { return nil }
    return get(url: url)
  }

  static func get(url: URL) -> URLRequest {
    request(url: url, method: "GET")
  }

  static func head(url string: String) -> URLRequest? {
    guard let url = URL(string: string) else { return nil }
    return request(url: url, method: "HEAD")
  }

}

private func request(url: URL, method: String) -> URLRequest {
  var request = URLRequest(url: url)
  request.httpMethod = method
  return request
}

extension URLRequest {
  mutating func setRangeHeader(value: ClosedRange<Int64>, unit: String = "bytes") {
    setValue("\(unit)=\(value.lowerBound)-\(value.upperBound)", forHTTPHeaderField: "Range")
  }
}

extension URLSessionDownloadTask {
  var progressPercentage: Double {
    Double(countOfBytesReceived) / Double(countOfBytesExpectedToReceive)
  }
  var isComplete: Bool {
    countOfBytesReceived == countOfBytesExpectedToReceive
  }
}