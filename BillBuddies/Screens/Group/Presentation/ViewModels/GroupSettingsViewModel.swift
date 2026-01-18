//
//  GroupSettingsViewModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation
import Combine

final class GroupSettingsViewModel: ObservableObject {

    private let fetchGroupMembersUseCase = FetchGroupMembersUseCase(repository: DependencyContainer.shared.groupsRepository)
    private let toastManager = DependencyContainer.shared.toastManager

    @Published var groupDetails: GroupMembersModel?

    @MainActor
    func fetchGroupMembers(groupId: String) {
        Task {
            let result = await fetchGroupMembersUseCase.execute(groupId: groupId)

            switch result {
            case .success(let data):
                self.groupDetails = data
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Something went wrong, please try again later!", style: .error)
            }
        }
    }
}
