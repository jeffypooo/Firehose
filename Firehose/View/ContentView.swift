//
//  ContentView.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: 8) {

        HStack {
          Spacer()
          Text("FIREHOSE v1.0.2")
              .font(.caption)
              .font(.system(size: 4))
              .mediumKerning()
          Spacer()
        }

        Text("Network").largeTitleStyle()

        horizontalDivider()

        HStack {
          Text("Download")
              .fontWeight(.regular)
              .font(.headline)
              .mediumKerning()

          Spacer()
          Text("22.1 MB/s")
              .font(.system(.subheadline, design: .monospaced))
              .mediumKerning()
        }
            .frame(maxWidth: geo.size.width / 2)

        HStack {
          Text("Connections")
              .fontWeight(.regular)
              .font(.headline)
              .mediumKerning()
          Spacer()
          Text("12")
              .font(.system(.subheadline, design: .monospaced))
              .mediumKerning()
        }
            .frame(maxWidth: geo.size.width / 2)

        HStack(alignment: .center) {
          Text("Downloads").largeTitleStyle()
          Spacer()
          AddDownloadButton()

        }
            .padding(.top, 12)

        horizontalDivider()

        DownloadList()

      }
          .padding()
    }

  }

  static func withDefaultConfiguration() -> some View {
    ContentView()
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: .infinity,
            minHeight: 450,
            idealHeight: 450,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(ContentBackground())
        .edgesIgnoringSafeArea(.top)
  }

}

struct ContentBackground: View {
  var body: some View {
    GeometryReader { proxy in
      RadialGradient(
          gradient: Gradient.backgroundLightDark,
          center: .center,
          startRadius: 2,
          endRadius: proxy.maxDimension / 1.5
      )
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView.withDefaultConfiguration()
        .frame(width: 800, height: 900)
  }
}

struct AddDownloadButton: View {
  @State private var showModal: Bool = false

  var body: some View {
    Button(action: { self.showModal = true }, label: { Image("add").frame(minWidth: 36, minHeight: 36) })
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.accentLight)
        .sheet(isPresented: self.$showModal) {
          AddDownloadView()
        }
  }
}


