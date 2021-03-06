import Foundation

extension DateFormatter {
  public static var defaultFormat: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US")
    df.timeZone = TimeZone(identifier: "America/Detroit")
    df.dateFormat = "MM-dd-yyyy h:mm a"
    return df
  }
}
