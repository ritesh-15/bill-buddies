//
//  GroupDetailsViewModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation
import Combine

final class GroupDetailsViewModel: ObservableObject {

    private let toastManager = DependencyContainer.shared.toastManager
    private let fetchGroupDetailsUseCase = FetchGroupDetailsUseCase(groupsRepository: DependencyContainer.shared.groupsRepository)

    // MARK: - Observed properties

    @Published var groupDetails: GroupDetailResponseModel?

    // MARK: - Public methods

    @MainActor
    func fetchGroupDetails(groupId: String) {
        Task {
            let result = await fetchGroupDetailsUseCase.execute(groupId: groupId)

            switch result {
            case .success(let data):
                self.groupDetails = data
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Something weng wrong please try again!", style: .error)
            }
        }
    }
}
