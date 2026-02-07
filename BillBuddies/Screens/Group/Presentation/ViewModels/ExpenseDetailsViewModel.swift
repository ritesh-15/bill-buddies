import Foundation
import Combine
import os

final class ExpenseDetailsViewModel: ObservableObject {

    // MARK: - Private properties

    private let fetchExpenseDetailUseCase: FetchExpenseDetailsUseCase = FetchExpenseDetailsUseCase(repository: DependencyContainer.shared.expenseRepository)
    private let toastManager: ToastManager = DependencyContainer.shared.toastManager

    private var router: NavigationRouter?

    @Published var expenseDetail: ExpenseDetailModel?

    // MARK: - Public methods

    func configure(router: NavigationRouter) {
        self.router = router
    }

    @MainActor
    func fetchExpenseDetails(expenseId: String, fetchForce: Bool = false) async {
        let result = await fetchExpenseDetailUseCase.execute(expenseId: expenseId)

        switch result {
        case .success(let data):
            expenseDetail = data
        case .failure (let error):
            Logger.general.error("\(error.localizedDescription)")
            toastManager.show(message: "Failed to fetch the expense details. Please try again.", style: .error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.router?.pop()
            }
        }
    }
}
