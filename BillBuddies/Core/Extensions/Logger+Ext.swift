import os
import Foundation

extension Logger {
    private static let identifier = "com.BillBuddies.com"

    static let general = Logger(subsystem: identifier, category: "general")
    static let network = Logger(subsystem: identifier, category: "Network")
}
