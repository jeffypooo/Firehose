//
//  DownloadCell.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import SwiftUI
import CleanroomLogger
import Combine

struct DownloadCell: View {
  @ObservedObject var model: DownloadModel

  var body: some View {
    ZStack {
      GeometryReader { geo in
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.backgroundLight)
            .shadow(radius: 2, x: 0, y: 2)
      }
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(model.download.url.absoluteString)
              .fontWeight(.regular)
              .font(.system(.headline, design: .monospaced))
              .foregroundColor(.white)
              .lineLimit(1)
          Text(model.progressText)
              .font(.caption)
              .lightKerning()
              .foregroundColor(.init(white: 0.8))
          Text(model.durationText)
              .font(.caption)
              .lightKerning()
              .foregroundColor(.init(white: 0.8))
        }.foregroundColor(.black)
        Spacer()
        Group {
          Button(action: {}, label: { Image(model.posButtonIconName) })
              .buttonStyle(BorderlessButtonStyle())
              .foregroundColor(.accentLight)
          Button(action: {}, label: { Image("stop") })
              .buttonStyle(BorderlessButtonStyle())
              .foregroundColor(.accentLight)
        }
      }.padding()
    }
  }
}

extension DownloadState {
  var iconImageName: String {
    switch self {
    case .cancelled, .complete:
      return "restart"
    case .notStarted:
      return "play"
    case .paused:
      return "play"
    case .running:
      return "pause"
    }
  }

  var isStopButtonEnabled: Bool {
    switch self {
    case .paused, .running:
      return true
    default:
      return false
    }
  }

}

class DownloadModel: ObservableObject {
  let download: MultiPartDownload
  @Published var posButtonIconName: String = ""
  @Published var progressText = ""
  @Published var durationText = ""
  private var subs = Set<AnyCancellable>()

  init(download: MultiPartDownload) {
    self.download = download
    download.$state
        .map { state -> String in state.iconImageName }
        .assign(to: \.posButtonIconName, on: self)
        .store(in: &subs)
    Publishers.CombineLatest(download.$totalBytes, download.$completedBytes)
        .map { totalBytes, completedBytes -> String in
          let pct = (Double(completedBytes) / Double(totalBytes)) * 100.0
          let fmt = NumberFormatter()
          fmt.maximumIntegerDigits = 3
          fmt.minimumIntegerDigits = 1
          fmt.maximumFractionDigits = 1
          let percentage = "\(fmt.string(from: NSNumber(floatLiteral: pct)) ?? "?")%"
          let completedSize = completedBytes.toDataSize()
          let totalSize = totalBytes.toDataSize()
          let ratio = completedSize.string() + "/" + totalSize.string()
          return "Progress: \(percentage) (\(ratio))"
        }
        .throttle(for: .milliseconds(250), scheduler: RunLoop.main, latest: true)
        .assign(to: \.progressText, on: self)
        .store(in: &subs)
    download.$elapsedTime
        .map { elapsedTime -> String in
          let secondsDisplay = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
          let minDisplay = Int((elapsedTime / 60).truncatingRemainder(dividingBy: 60))
          let hoursDisplay = Int(elapsedTime / 3600)
          return "Duration: " + String(format: "%02d:%02d:%02d", hoursDisplay, minDisplay, secondsDisplay)
        }
        .assign(to: \.durationText, on: self)
        .store(in: &subs)
  }
}

extension Int64 {

  func toDataSize() -> DataSize {
    let byteSize = DataSize.bytes(self)
    if self <= 1024 {
      return byteSize
    } else if Double(self) < pow(1024, 2) {
      return byteSize.convert(to: .kilobytes)
    } else if Double(self) < pow(1024, 3) {
      return byteSize.convert(to: .megabytes)
    } else {
      return byteSize.convert(to: .gigabytes)
    }

  }

}




