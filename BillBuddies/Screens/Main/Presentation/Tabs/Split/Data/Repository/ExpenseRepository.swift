//
//  ExpenseRepository.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

protocol ExpenseRepositoryProtocol: AnyObject {

    func createExpense(expense: ExpenseRequestModel) async -> Result<CreateExpenseModel, NetworkError>

    func fetchRecentExpenses(userId: String) async -> Result<[RecentExpensesModel], NetworkError>
}

final class ExpenseRepository: ExpenseRepositoryProtocol {

    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func createExpense(expense: ExpenseRequestModel) async -> Result<CreateExpenseModel, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .post)
                .setPath(path: "/expenses/create")
                .addHeader(key: "Content-Type", value: "application/json")
                .setJSONBodyPreservingKeys(expense)
                .build()

            let result: NetworkResult<DTOCreateExpenseResponse> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(CreateExpenseResponseMapper.toDomain(data))
            case .failure(let networkError):
                return .failure(networkError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch _ {
            return .failure(.unknown)
        }
    }

    func fetchRecentExpenses(userId: String) async -> Result<[RecentExpensesModel], NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .get)
                .setPath(path: "/expenses")
                .addHeader(key: "Content-Type", value: "application/json")
                .addQuery("fields[0]", value: "id")
                .addQuery("fields[1]", value: "description")
                .addQuery("fields[2]", value: "date")
                .addQuery("fields[3]", value: "amount")
                .addQuery("populate[splitShares][fields][0]", value: "id")
                .addQuery("populate[splitShares][populate][ownedBy][fields][0]", value: "id")
                .addQuery("filters[$or][0][paidBy][documentId][$eq]", value: userId)
                .addQuery("filters[$or][1][splitShares][paidTo][documentId][$eq]", value: userId)
                .addQuery("filters[$or][1][splitShares][ownedBy][documentId][$eq]", value: userId)
                .addQuery("sort[createdAt]", value: "desc")
                .build()

            let result: NetworkResult<RecentExpensesDto> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(RecentExpensesResponseMapper.toDomain(data))
            case .failure(let networkError):
                return .failure(networkError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch _ {
            return .failure(.unknown)
        }
    }
}
