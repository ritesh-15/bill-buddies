import Foundation
import Testing
@testable import BillBuddies

struct NetworkRequestBuilderTest {

    @Test
    func testDefaultBaseURLAndGETWithoutExtras() throws {
        let builder = NetworkRequestBuilder()
        let request = try builder.build()

        #expect(request.httpMethod == HTTPMethod.get.rawValue)
        #expect(request.allHTTPHeaderFields?.isEmpty ?? true)
        #expect(request.httpBody == nil)
        #expect(request.url?.absoluteString == "http://localhost/v1/api")
    }

    @Test
    func testCustomBaseURLInit() throws {
        let baseURL = "https://example.com/api"
        let builder = NetworkRequestBuilder(baseURL: baseURL)
        let request = try builder.build()

        #expect(request.url?.absoluteString == baseURL)
    }

    @Test
    func testSetPathAppendsToBaseURL() throws {
        let baseURL = "https://example.com/api"
        let request = try NetworkRequestBuilder(baseURL: baseURL)
            .setPath(path: "/users")
            .build()

        #expect(request.url?.absoluteString == "https://example.com/api/users")
    }

    @Test
    func testMethodAssignment() throws {
        let request = try NetworkRequestBuilder()
            .method(method: .post)
            .build()

        #expect(request.httpMethod == HTTPMethod.post.rawValue)
    }

    @Test
    func testHeadersAccumulation() throws {
        let request = try NetworkRequestBuilder()
            .addHeader(key: "Accept", value: "application/json")
            .addHeader(key: "Authorization", value: "Bearer token")
            .build()

        let headers = try #require(request.allHTTPHeaderFields)
        #expect(headers["Accept"] == "application/json")
        #expect(headers["Authorization"] == "Bearer token")
    }

    @Test
    func testSingleQueryParameterForGET() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .addQuery("q", value: "swift")
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = components.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "q", value: "swift")))
    }

    @Test
    func testMultipleQueryParametersForGET() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .addQuery([
                "page": 2,
                "pageSize": 50,
                "search": "network builder"
            ])
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = components.queryItems ?? []

        // Values are stringified by the builder
        #expect(items.contains(URLQueryItem(name: "page", value: "2")))
        #expect(items.contains(URLQueryItem(name: "pageSize", value: "50")))
        #expect(items.contains(URLQueryItem(name: "search", value: "network builder")))
    }

    @Test
    func testNonGETDoesNotAppendQueryItems() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .method(method: .post)
            .addQuery("q", value: "swift")
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.queryItems == nil || components.queryItems?.isEmpty == true)
    }

    private struct SampleBody: Encodable, Equatable {
        let firstName: String
        let lastName: String
        let favoriteNumber: Int
    }

    @Test
    func testJSONBodyEncodingAndContentTypeHeader() throws {
        let body = SampleBody(firstName: "John", lastName: "Appleseed", favoriteNumber: 42)

        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .method(method: .post)
            .setJSONBody(body)
            .build()

        // Content-Type header set by setJSONBody
        let headers = try #require(request.allHTTPHeaderFields)
        #expect(headers["Content-Type"] == "application/json")

        // Verify body encodes using convertToSnakeCase
        let data = try #require(request.httpBody)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let encodedKeys = try #require(jsonObject)

        // Keys should be snake_case due to encoder strategy
        #expect(encodedKeys["first_name"] as? String == "John")
        #expect(encodedKeys["last_name"] as? String == "Appleseed")
        #expect(encodedKeys["favorite_number"] as? Int == 42)
    }

    @Test
    func testStrapiPopulateAllWhenNoFieldsProvided() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .populate()
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = components.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "populate", value: "*")))
    }

    @Test
    func testStrapiPopulateSpecificFields() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .populate("author", "comments", "tags")
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = components.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "populate", value: "author,comments,tags")))
    }

    @Test
    func testStrapiFilter() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .filter("status", value: "published")
            .build()

        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = components.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "filters[status]", value: "published")))
    }

    @Test
    func testStrapiSortAscendingAndDescending() throws {
        let ascendingRequest = try NetworkRequestBuilder(baseURL: "https://example.com")
            .sort("createdAt", ascending: true)
            .build()

        let descendingRequest = try NetworkRequestBuilder(baseURL: "https://example.com")
            .sort("createdAt", ascending: false)
            .build()

        let ascURL = try #require(ascendingRequest.url)
        let descURL = try #require(descendingRequest.url)

        let ascItems = try #require(URLComponents(url: ascURL, resolvingAgainstBaseURL: false)).queryItems ?? []
        let descItems = try #require(URLComponents(url: descURL, resolvingAgainstBaseURL: false)).queryItems ?? []

        #expect(ascItems.contains(URLQueryItem(name: "sort", value: "createdAt")))
        #expect(descItems.contains(URLQueryItem(name: "sort", value: "createdAt:desc")))
    }

    @Test
    func testStrapiPagination() throws {
        let request = try NetworkRequestBuilder(baseURL: "https://example.com")
            .pagination(page: 3, pageSize: 25)
            .build()

        let url = try #require(request.url)
        let items = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)).queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "pagination[page]", value: "3")))
        #expect(items.contains(URLQueryItem(name: "pagination[pageSize]", value: "25")))
    }
}
