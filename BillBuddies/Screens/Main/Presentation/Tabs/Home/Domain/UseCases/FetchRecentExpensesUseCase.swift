//
//  FetchRecentExpensesUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation

final class FetchRecentExpensesUseCase {

    private let expenseRepository: ExpenseRepositoryProtocol

    init(expenseRepository: ExpenseRepositoryProtocol) {
        self.expenseRepository = expenseRepository
    }

    func execute(userId: String) async -> Result<[RecentExpensesModel], NetworkError> {
        let result = await expenseRepository.fetchRecentExpenses(userId: userId)
        return result
    }
}
