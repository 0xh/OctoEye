//
//  GithubClientSpec.swift
//  Tests
//
//  Created by mzp on 2017/07/07.
//  Copyright © 2017 mzp. All rights reserved.
//

import BrightFutures
import GraphQLicious
import JetToTheFuture
import Nimble
import Quick
import Result

internal class MockHttpRequest: HttpRequestProtocol {
    private let future: Future<Data, AnyError>

    init(future: Future<Data, AnyError>) {
        self.future = future
    }

    convenience init(response: String) {
        // swiftlint:disable:next force_unwrapping
        let value = response.data(using: .utf8)!
        self.init(future: Future<Data, AnyError>(value: value))
    }

    func post(url: URL, query: String, accessToken: String) -> Future<Data, AnyError> {
        return future
    }
}

internal class GithubClientSpec: QuickSpec {
    internal struct SampleResponse: Codable {
    }

    private func github(future: Future<Data, AnyError>) -> GithubClient {
        return GithubClient(token: "-", httpRequest: MockHttpRequest(future: future))
    }

    override func spec() {
        let query = Query(request: Request(name: "repository"))

        describe("error handling") {
            it("return http request error") {
                let error = Result<SampleResponse, AnyError>.error(nil)
                let future = Future<Data, AnyError>(error: AnyError(error))
                let r = forcedFuture { _ -> Future<SampleResponse, AnyError> in
                    self.github(future: future).query(query)
                }
                expect(r.value).to(beNil())
            }

            it("return json parsing error") {
                // swiftlint:disable:next force_unwrapping
                let future = Future<Data, AnyError>(value: "{ \"datum\": {} }".data(using: .utf8)!)

                let r = forcedFuture { _ -> Future<SampleResponse, AnyError> in
                    self.github(future: future).query(query)
                }

                expect(r.value).to(beNil())
            }
        }
        describe("return value") {
            it("return decoded value") {
                // swiftlint:disable:next force_unwrapping
                let future = Future<Data, AnyError>(value: "{ \"data\": {} }".data(using: .utf8)!)

                let r = forcedFuture { _ -> Future<SampleResponse, AnyError> in
                    self.github(future: future).query(query)
                }

                expect(r.value).toNot(beNil())
            }
        }
    }
}
