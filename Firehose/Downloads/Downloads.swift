//
//  Download.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import Combine
import CleanroomLogger

struct DownloadMetadata {
  let acceptsRanges: Bool
  let mimeType: String
  let contentLength: Int64
}

enum DownloadState {
  case notStarted
  case running
  case paused
  case cancelled
  case complete
}

class MultiPartDownload: NSObject, ObservableObject {
  let url: URL
  let metadata: DownloadMetadata
  let numConnections: Int
  var startTime: TimeInterval?
  private var tasks = Set<URLSessionDownloadTask>()

  @Published var state: DownloadState = .notStarted
  @Published var completedBytes: Int64 = 0
  @Published var totalBytes: Int64 = 0
  @Published var elapsedTime: TimeInterval = 0
  var subs = Set<AnyCancellable>()

  init(url: URL, metadata: DownloadMetadata, numConnections: Int) {
    self.url = url
    self.metadata = metadata
    self.numConnections = numConnections
    self.totalBytes = metadata.contentLength
    super.init()
  }

  func start() {
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    let ranges = computeRanges(numConnections: numConnections, size: metadata.contentLength)
    ranges.forEach { range in
      var req = URLRequest.get(url: url)
      req.setRangeHeader(value: range)
      tasks.insert(session.downloadTask(with: req))
    }
    startTime = Date.timeIntervalSinceReferenceDate
    state = .running
    tasks.forEach { $0.resume() }
    Log.debug?.message("started!")
  }
}

extension MultiPartDownload: URLSessionDownloadDelegate {
  public func urlSession(
      _ session: URLSession,
      downloadTask: URLSessionDownloadTask,
      didWriteData bytesWritten: Int64,
      totalBytesWritten: Int64,
      totalBytesExpectedToWrite: Int64
  ) {
    completedBytes = tasks.reduce(Int64(0)) { acc, task in acc + task.countOfBytesReceived }
  }

  public func urlSession(
      _ session: URLSession,
      downloadTask: URLSessionDownloadTask,
      didFinishDownloadingTo location: URL
  ) {
    checkForCompletion()
  }

  private func checkForCompletion() {
    Log.debug?.trace()
    let areAllTasksComplete = tasks.reduce(true) { res, next in res && next.isComplete }
    if (areAllTasksComplete) {
      state = .complete
      Log.debug?.message("completed!")
    }

  }
}

private func computeRanges(numConnections: Int, size: Int64) -> [ClosedRange<Int64>] {
  let (chunkSize, remainder) = size.quotientAndRemainder(dividingBy: Int64(numConnections))
  var chunks: [ClosedRange<Int64>] = []
  for i in 0..<Int64(numConnections) {
    let isLast = i == (numConnections - 1)
    let beg = i * chunkSize
    let end = isLast ? beg + chunkSize + remainder : beg + chunkSize
    chunks.append(beg...end)
  }
  return chunks
}
