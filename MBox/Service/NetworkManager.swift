//
//  NetworkManager.swift
//  MBox
//
//  Created by YoonieMac on 4/17/26.
//

import Foundation
import Combine


// MARK: - NetworkManager
/// TMDB API를 사용하여 영화 데이터를 로드하는 네트워크 관리자
struct NetworkManager {
	
	// MARK: - Properties
	/// TMDB API 키 (인증에 사용)
	private let apiKey = "26bc3a347d35e9e11f08e0ac83a85319"
	/// TMDB 기본 URL
	private let baseURL = "https://api.themoviedb.org/3"
	/// 응답 언어 설정 (한국어)
	private let language = "ko-KR"
	
	// MARK: - EndPoints
	//https://api.themoviedb.org/3/movie/now_playing?api_key=26bc3a347d35e9e11f08e0ac83a85319&language=ko-KR&page=1
	
	/// 최신 개봉작 URL 생성
	///  - Parameter: page(페이지 번호)
	///  - Return: 최신 개봉작 API URL String
	private func nowPlayingURL(page: Int) -> String {
		return "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=\(language)&page=\(page)"
	}
	
	/// 인기 영화 URL 생성
	///  - Parameter: page(페이지 번호)
	///  - Return: 인기 영화 API URL String
	private func popularMoviesURL(page: Int) -> String {
		return "\(baseURL)/movie/popular?api_key=\(apiKey)&language=\(language)&page=\(page)"
	}
	
	/// 최고 평점 영화 URL 생성
	///  - Parameter: page(페이지 번호)
	///  - Return: 최고 평점 영화 API URL String
	private func topRatedMoviesURL(page: Int) -> String {
		return "\(baseURL)/movie/top_rated?api_key=\(apiKey)&language=\(language)&page=\(page)"
	}
	
	/// 개봉 예정 영화 URL 생성
	///  - Parameter: page(페이지 번호)
	///  - Return: 개봉 예정 영화 API URL String
	private func upComingMoviesURL(page: Int) -> String {
		return "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=\(language)&page=\(page)"
	}
	
	// MARK: - 데이터 로드 메서드
	/// 주어진 URL에서 영화 데이터를 가져오는 메서드
	/// TMDB API와 통신하여 JSON 데이터를 디코딩하고, Movie 배열을 반환합니다
	/// - Parameter: urlString: 호출할 URL API String
	/// - Return: Movie 배열을 포함하는 combine Publisher
	func fetchMovies(_ urlString: String) -> AnyPublisher<[Movie], Error> {
		// 1. 유효성 검사
		guard let url = URL(string: urlString) else {
			// URL이 유효하지 않은 경우, 실패 publisher를 반환(Error publisher)
			// URLError(.badURL) URL 변환 실패를 의미
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}
		// 2. URLSession을 통해 비동기 API 요청을 수행
		return URLSession.shared.dataTaskPublisher(for: url)
		// 3. API 응답 데이터 추출: 응답에서 data 부분만 가져옴
			.map { $0.data }
		// 4. Json 디코딩: MovieResponse 객체로 변환 -> 디코딩 작업을 통해 Json 데이터를 Swift 타입으로 변환
			.decode(type: MovieResponse.self, decoder: JSONDecoder())
		// 5. 디코딩된 데이터에서 results (영화배열)만 추출 -> MovieResponse 내부의 results를 가져와 영화배열만 반환
			.map { $0.results }
		// 6. 결과를 메인스레드에서 실행 - SwiftUI는 UI업데이트가 메인스레드에서 이뤄져야 함
			.receive(on: DispatchQueue.main)
		// 7. 퍼블리셔 타입을 AnyPublisher 로 변환 -> Combine 체인의 세부사항을 외부에 노출하지 않도록 만듭니다.
			.eraseToAnyPublisher()
	}
	
	// MARK: - API 호출 메서드
	/// 최신 개봉작 데이터 로드
	/// - Parameter: page 페이지 번호
	/// - Return: Movie 배열을 포함한 Combine 퍼블리셔
	func fetchNowPlayingMovies(page: Int) -> AnyPublisher<[Movie], Error> {
		return fetchMovies(nowPlayingURL(page: page))
	}
	
	/// 인기영화 데이터 로드
	/// - Parameter: page 페이지 번호
	/// - Return: Movie 배열을 포함한 Combine 퍼블리셔
	func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error> {
		return fetchMovies(popularMoviesURL(page: page))
	}
	
	/// 최고 평점 영화 데이터 로드
	/// - Parameter: page 페이지 번호
	/// - Return: Movie 배열을 포함한 Combine 퍼블리셔
	func fetchTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error> {
		return fetchMovies(topRatedMoviesURL(page: page))
	}
	
	/// 개봉 예정 영화 데이터 로드
	/// - Parameter: page 페이지 번호
	/// - Return: Movie 배열을 포함한 Combine 퍼블리셔
	func fetchUpComingMovies(page: Int) -> AnyPublisher<[Movie], Error> {
		return fetchMovies(upComingMoviesURL(page: page))
	}
}


/*
 /*
  API key: "26bc3a347d35e9e11f08e0ac83a85319"
  baseURL: https://api.themoviedb.org/3
  language: ko-KR

  참조:
  API: https://developer.themoviedb.org/docs/authentication-application
  Languages: https://developer.themoviedb.org/docs/languages
  */

 /*
  목적: network를 Combine으로 자동 업데이트를 시킨다.
  로직: 각 검색목록의 URLString 생성 -> 4개 endpoints -> fetch(AnyPublisher로) -> 각각의 Publisher operator만 반환
  */


 struct NetworkManager {
	 // MARK: - URL을 만들기 위한 기초 정보 baseURL, apiKey, language
	 private let apiKey = "26bc3a347d35e9e11f08e0ac83a85319"
	 private let baseURL = "https://api.themoviedb.org/3"
	 private let language = "ko-KR"
	 
	 // MARK: - urlString 만들기 함수(page, partialPath) 파라미터
	 private func makeUrlString(movieLists: MovieLists, page: Int) -> String {
		 print("\(baseURL)\(movieLists.partialUrlString)?api_key=\(apiKey)&language=\(language)&page=\(page)")
		 return "\(baseURL)\(movieLists.partialUrlString)?api_key=\(apiKey)&language=\(language)&page=\(page)"
	 }
	 
	 // MARK: - fetchNetworkPublisher
	 func fetchMovies(urlString: String, page: Int) -> AnyPublisher<[Movie], Error> {
		 guard let url = URL(string: urlString) else {
			 return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		 }
		 return URLSession.shared.dataTaskPublisher(for: url)
			 .map { $0.data }
			 .decode(type: MovieResponse.self, decoder: JSONDecoder())
			 .map { $0.results }
			 .receive(on: DispatchQueue.main)
			 .eraseToAnyPublisher()
	 }
	 
	 // MARK: - 개별 [Movie] 배열 생성
	 func sortedMovies(movieLists: MovieLists, page: Int) -> AnyPublisher<[Movie], Error> {
		 let urlString = makeUrlString(movieLists: movieLists, page: page)
		 return fetchMovies(urlString: urlString, page: page)
	 }
 }

 */
