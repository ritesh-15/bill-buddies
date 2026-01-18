//
//  HomeScreenViewModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation
import Combine
import os

final class HomeScreenViewModel: ObservableObject {

    private let fetchMembersUseCase = FetchMembersUseCase(membersRepository: DependencyContainer.shared.membersRepository)
    private let fetchRecentExpensesUseCase = FetchRecentExpensesUseCase(expenseRepository: DependencyContainer.shared.expenseRepository)

    private var authManager: AuthManager?

    @Published var members: [MembersModel] = []
    @Published var recentExpenses: [RecentExpensesModel] = []

    // MARK: - Public methods

    func configure(authManager: AuthManager) {
        self.authManager = authManager
    }

    @MainActor
    func fetchMembers() {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            let result = await fetchMembersUseCase.execute(userId: me.id)

            switch result {
            case .success(let data):
                self.members = data
            case .failure(let failure):
                Logger.general.error("Failed to fetch members: \(failure)")
            }
        }
    }

    @MainActor
    func fetchRecentExpenses() {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            let result = await fetchRecentExpensesUseCase.execute(userId: me.id)

            switch result {
            case .success(let data):
                self.recentExpenses = data
            case .failure(let failure):
                Logger.general.error("Failed to fetch recent expenses: \(failure)")
            }
        }
    }
}
