import Foundation
import Combine

struct Member: Identifiable {
    let id = UUID()
    let memberName: String
    let memberUsername: String
}

class CreateGroupViewModel: ObservableObject {

    @Published var groupName: String = ""
    @Published var memberSearchText: String = ""
    @Published var shouldShowAddMembersScreen: Bool = false

    @Published var members: [Member] = [
        Member(memberName: "Ritesh Khore", memberUsername: "rkhore"),
        Member(memberName: "Kaustubh Gade", memberUsername: "kgade"),
        Member(memberName: "Ronit Khalate", memberUsername: "rkhalate"),
        Member(memberName: "Atharava Jadhav", memberUsername: "atjadhav"),
        Member(memberName: "Pratik Ghadge", memberUsername: "pghadge"),
        Member(memberName: "Aditya Jadhav", memberUsername: "ajadhav"),
        Member(memberName: "Yash Banakar", memberUsername: "ybanakar"),
    ]

    @Published var selectedMembers: [Member] = []

    func toggleMemember(member: Member) {
        if isMemberSelected(member: member) {
            selectedMembers.removeAll { it in
                it.id == member.id
            }
            return
        }

        selectedMembers.append(member)
    }

    func isMemberSelected(member: Member) -> Bool {
        return selectedMembers.contains(where: { it in
            it.id == member.id
        })
    }
}
