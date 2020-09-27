//
// Created by Jefferson Jones on 9/27/20.
// Copyright (c) 2020 Jefferson Jones. All rights reserved.
//

import Foundation

struct DataSize {

  let size: Double
  let unit: Unit

  func convert(to dest: Unit) -> DataSize {
    let bytes = unit.byteCount(size)
    return DataSize(size: dest.from(bytes: bytes), unit: dest)
  }

  enum Unit {
    case bytes
    case kilobytes
    case megabytes
    case gigabytes

    var abbreviation: String {
      switch self {
      case .bytes:
        return "B"
      case .kilobytes:
        return "KB"
      case .megabytes:
        return "MB"
      case .gigabytes:
        return "GB"
      }
    }

    var multiplier: Double {
      switch self {
      case .bytes:
        return 1
      case .kilobytes:
        return 1024
      case .megabytes:
        return pow(1024, 2)
      case .gigabytes:
        return pow(1024, 3)
      }
    }

    func from<T: BinaryInteger>(bytes: T) -> Double {
      return from(bytes: Double(bytes))
    }

    func from<T: BinaryFloatingPoint>(bytes: T) -> Double {
      return Double(bytes) / multiplier
    }

    func byteCount<T: BinaryFloatingPoint>(_ cnt: T) -> Double {
      return Double(cnt) * multiplier
    }
  }
}

extension DataSize {
  static func bytes<T: BinaryInteger>(_ size: T) -> DataSize {
    return DataSize(size: Double(size), unit: .bytes)
  }

  static func kilobytes<T: BinaryFloatingPoint>(_ size: T) -> DataSize {
    return DataSize(size: Double(size), unit: .kilobytes)
  }

  static func megabytes<T: BinaryFloatingPoint>(_ size: T) -> DataSize {
    return DataSize(size: Double(size), unit: .megabytes)
  }

  static func gigabytes<T: BinaryFloatingPoint>(_ size: T) -> DataSize {
    return DataSize(size: Double(size), unit: .gigabytes)
  }
}

extension DataSize {
  func string(withAbbreviation: Bool = true) -> String {
    let fmt = NumberFormatter()
    fmt.minimumIntegerDigits = 1
    fmt.maximumFractionDigits = 2
    let formatted = fmt.string(from: NSNumber(floatLiteral: size)) ?? "?"
    return withAbbreviation ? formatted + unit.abbreviation : formatted
  }
}

func /(left: DataSize, right: DataSize) -> DataSize {
  let leftConverted = left.convert(to: right.unit)
  return DataSize(size: leftConverted.size / right.size, unit: right.unit)
}
