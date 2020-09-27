//
//  List.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/16/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CleanroomLogger

struct ListFooter: View {
  let itemCount: Int
  var body: some View {
    HStack {
      Spacer()
      Text("\(itemCount) items")
      Spacer()
    }
  }
}

struct DownloadList: View {
  @ObservedObject var model = DownloadInfoListModel()
  var body: some View {
    ScrollView {
      VStack {
        ForEach(model.downloads) { info in
          DownloadCell(model: DownloadModel(download: info))
        }
        ListFooter(itemCount: model.downloads.count)

      }
    }
  }
}

class DownloadInfoListModel: ObservableObject {

  @Published var downloads: [MultiPartDownload] = []
  private var subs: Set<AnyCancellable> = []

  init() {
    $downloads.sink { list in
      Log.debug?.message("downloads: \(list.count)")
    }.store(in: &subs)
    DownloadController.shared.$downloads
        .assign(to: \.downloads, on: self)
        .store(in: &subs)
  }

}

extension MultiPartDownload: Identifiable {
  var id: String {
    url.absoluteString
  }
}