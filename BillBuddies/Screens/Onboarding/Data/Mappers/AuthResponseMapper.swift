import Foundation

struct AuthResponseMapper {

    static func toDomain(_ dto: AuthResponseDTO) -> AuthResult {
        return AuthResult(
            token: dto.jwt,
            refreshToken: dto.refreshToken,
            user: User(
                id: dto.user.documentID,
                email: dto.user.email,
                username: dto.user.username)
        )
    }
}
