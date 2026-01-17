//
//  ExpenseRepository.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

protocol ExpenseRepositoryProtocol: AnyObject {

    func createExpense(expense: ExpenseRequestModel) async -> Result<CreateExpenseModel, NetworkError>
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
}
