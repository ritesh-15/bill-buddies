//
//  CreateExpenseUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

final class CreateExpenseUseCase {

    private let repository: ExpenseRepositoryProtocol

    init(repository: ExpenseRepositoryProtocol) {
        self.repository = repository
    }

    func execute(expense: ExpenseRequestModel) async -> Result<CreateExpenseModel, NetworkError> {
        let result = await repository.createExpense(expense: expense)
        return result
    }
}
