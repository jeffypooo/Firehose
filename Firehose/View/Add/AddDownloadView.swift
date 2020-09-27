//
//  AddDownloadView.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/16/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import SwiftUI
import CleanroomLogger

struct AddDownloadView_Previews: PreviewProvider {

  static var previews: some View {
    AddDownloadView()
  }
}

struct AddDownloadView: View {

  @Environment(\.presentationMode) var presentationMode

  @State private var url: String = ""
  @State private var connectionSelection = 3
  @State private var isAutoStartOn = true


  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HeaderLabel()

      horizontalDivider()

      URLInput(value: self.$url)
          .padding(.bottom, 16)

      ConnectionsPicker(selection: self.$connectionSelection)
          .padding(.bottom, 16)

      AutoStartToggle(isOn: self.$isAutoStartOn)
          .padding(.bottom, 16)

      horizontalDivider()

      ActionButtons(onCancel: dismiss, onAdd: add)
          .padding()

    }
        .frame(width: 500)
        .padding()
  }

  private func dismiss() {
    self.presentationMode.wrappedValue.dismiss()
  }

  private func add() {
    DownloadController.shared.getDownload(
        url: url,
        numConnections: connectionSelection + 1,
        onComplete: {
          $0.start()
          dismiss()
        },
        onError: { error in
          Log.error?.value(error)
        }
    )
  }

}

private struct HeaderLabel: View {
  var body: some View {
    HStack {
      Spacer()
      Text("Add new download")
          .font(.title)
          .mediumKerning()
      Spacer()
    }
  }
}

private struct URLInput: View {
  let value: Binding<String>
  var body: some View {
    VStack(alignment: .leading) {
      Text("URL").font(.caption).mediumKerning()
      HStack {
        TextField("URL", text: self.value)
            .font(.system(.body, design: .monospaced))
            .textFieldStyle(RoundedBorderTextFieldStyle())

      }
    }
  }
}

private struct ConnectionsPicker: View {
  let selection: Binding<Int>
  var body: some View {
    VStack(alignment: .leading) {
      Text("CONNECTIONS").font(.caption).mediumKerning()
      Picker(
          selection: self.selection,
          label: EmptyView()
      ) {
        ForEach(0..<32) {
          Text("\($0 + 1)")
        }
      }
    }
  }
}

private struct AutoStartToggle: View {
  let isOn: Binding<Bool>
  var body: some View {
    Toggle<Text>(
        isOn: self.isOn,
        label: { Text("Start now").font(.body).mediumKerning() }
    )
        .toggleStyle(SwitchToggleStyle())
  }
}

private struct ActionButtons: View {
  let onCancel: () -> Void
  let onAdd: () -> Void
  var body: some View {
    HStack {
      Spacer()
      Button(
          action: onCancel,
          label: { Text("Cancel").font(.callout).mediumKerning() }
      )
          .buttonStyle(LinkButtonStyle())
          .foregroundColor(.gray)

      Spacer()
      Button(
          action: onAdd,
          label: { Text("Add").font(.callout).mediumKerning() }
      )
          .buttonStyle(LinkButtonStyle())
          .foregroundColor(.accentLight)
      Spacer()

    }
  }
}
