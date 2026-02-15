import Foundation

struct GroupsResponseMapper {

    // Maps an entire DTOGroups payload to an array of domain GroupsModel
    static func toDomain(_ dto: DTOGroups) -> [GroupsModel] {
        return dto.data.map { toDomain($0) }
    }

    // Maps a single DTODatum to a domain GroupsModel
    static func toDomain(_ dto: DTODatum) -> GroupsModel {
        return GroupsModel(
            id: dto.id,
            documentId: dto.documentId,
            name: dto.name,
            description: dto.description,
            category: GroupCategory(rawValue: dto.category ?? "") ?? .other,
            simplifyDebts: dto.simplifyDebts,
            createdAt: dto.createdAt,
            creator: toDomain(dto.creator),
            members: dto.members.map { toMemberDomain($0) }
        )
    }

    // Maps DTOCreator to domain CreatorModel (for creator field)
    private static func toDomain(_ dto: DTOCreator) -> CreatorModel {
        return CreatorModel(
            id: dto.id,
            documentId: dto.documentId,
            username: dto.username
        )
    }

    // Maps DTOCreator to domain MemberModel (for members array)
    private static func toMemberDomain(_ dto: DTOCreator) -> MemberModel {
        return MemberModel(
            id: dto.id,
            documentId: dto.documentId,
            username: dto.username
        )
    }

    static func toEntity(_ dto: DTOGroups) -> [SDGroupEntity] {
        return dto.data.map { dto in
            let entity = SDGroupEntity(
                name: dto.name,
                category: dto.category ?? "",
                simplifyDebts: false,
                id: dto.id,
                documentId: dto.documentId,
                isDeleted: false,
                isSynced: true)

            entity.members = dto.members.map({ memberDto in
                return SDMemberEntity(
                    id: memberDto.id,
                    documentId: memberDto.documentId,
                    isDeleted: false,
                    isSynced: true,
                    username: memberDto.username)
            })
            return entity
        }
    }
}
