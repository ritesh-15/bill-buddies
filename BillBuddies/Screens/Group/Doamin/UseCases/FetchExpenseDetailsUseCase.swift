//
//  FetchExpenseDetailsUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation

final class FetchExpenseDetailsUseCase {

    private let repository: ExpenseRepositoryProtocol

    init(repository: ExpenseRepositoryProtocol) {
        self.repository = repository
    }

    func execute(expenseId: String) async -> Result<ExpenseDetailModel, NetworkError> {
        let result = await repository.fetchExpenseDetails(expenseId: expenseId)
        return result
    }
}
