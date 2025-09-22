import Foundation
import Combine

final class MainScreenViewModel: ObservableObject {

    enum TabItem: Hashable {
        case home
        case groups
        case split
        case stats
        case settings
    }

    // MARK: - Observed properties

    @Published var selection: TabItem = .home
    @Published private(set) var previousSelection: TabItem = .home
    @Published var showCreate: Bool = false

    // MARK: - Public methods

    func onTabChange(_ new: TabItem) {
        if new == .split {
            showCreate = true
        } else {
            previousSelection = new
        }
    }

    func switchToPreviousTab() {
        selection = previousSelection
    }
}
