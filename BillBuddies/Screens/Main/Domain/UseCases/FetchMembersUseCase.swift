//
//  FetchMembersUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

final class FetchMembersUseCase {

    private let membersRepository: MembersRepositoryProtocol

    init(membersRepository: MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }

    func execute(query: String = "", userId: String) async -> Result<[MembersModel], NetworkError> {
        let result = await membersRepository.fetchMembers(query: query, userId: userId)
        return result
    }
}
