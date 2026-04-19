//
//  Movie.swift
//  MBox
//
//  Created by YoonieMac on 4/17/26.
//

import Foundation
import SwiftUI


/*
 1. API Key 발급받기
 https://www.themoviedb.org
 회원 가입 후, API Key 입력해 놓기
 API key: "26bc3a347d35e9e11f08e0ac83a85319"
 
 2. API 구조 설명
 https://developer.themoviedb.org/docs/getting-started
 Json 에서 사용할 값: id, title, overview, releaseDate, voteAverage, posterPath
 */

// MARK: - MovieResponse
///TMDB API 에서 영화 데이터를 받아오는 응답 모델
///응답에 'results'라는 이름으로 영화 배열 데이터를 포함함
struct MovieResponse: Codable {
	let results: [Movie]
	
}

// MARK: - Movie
/// TMBD API 의 개별 영화 데이터를 표현하는 모델
/// API 응답에서 개별 영화 정보를 파싱하는데 사용됨
struct Movie: Identifiable, Codable, Equatable {
	
	//properties
	let id: Int  // 영화 고유 ID
	let title: String // 영화 제목
	let overview: String // 영화 줄거리
	let releaseDate: String // 개봉일
	let voteAverage: Double // 평균평점
	let posterPath: String? // 포스터 이미지 경로 (Optional)
	// 완전한 포스터 이미지 경로 "https://image.tmdb.org/t/p/w500/이름.jpg"
	
	/// TMDB 이미지 URL 생성
	/// 포스트 경로를 포함해 완전한 이미지 URL 구성
	/// -포스터 경로가 없는 경우 nil 반환
	/// 참조: https://developer.themoviedb.org/docs/image_basics
	var posterURL: URL? {
		guard let path = self.posterPath else {return nil}
		return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
	}
	
	// MARK: - Coding Keys
	/// JSON 응답의 키와 Swift 속성 이름이 일치하지 않는 경우 매칭을 정의
	enum CodingKeys: String, CodingKey {
		case id, title, overview
		case releaseDate = "release_date"
		case voteAverage = "vote_average"
		case posterPath = "poster_path"
	}
	
	// MARK: - Mock Data
	/// 테스트 및 미리보기 용 Mock 데이터
	static let mock = Movie(
		id: 1470130,
		title: "테스트용 무비",
		overview: "이것은 테스트용 무비 데이터 줄거리 입니다",
		releaseDate: "2026-02-13",
		voteAverage: 8.863,
		posterPath: "/72AoFPC5TY4DfJwXXS9rPwPeReD.jpg"
	)
	
	// MARK: - Equatable 설정
	/// 두 Movie 객체가 같은 ID 값을 비교해서 동일 여부 결정
	/// Swift의 == 연산자를 사용자 정의하기 위해 사용함. ForEach 배열 데이터를 처리할 때 고유성 여부 확인시 사용
	/// - parameter:
	/// 	- lhs: 비교할 첫번째 Movie 객체
	/// 	- rhs: 비교할 두번째 Movie 객체
	/// - return: 두 객체의 id가 동일하면 true, 다르면 false
	static func == (lhs: Movie, rhs: Movie) -> Bool {
		return lhs.id == rhs.id
	}
}

/*

enum MovieLists: CaseIterable {
	case nowPlaying
	case popular
	case topLated
	case upcoming
	
	var description: String {
		switch self {
		case .nowPlaying: return "최신 개봉작"
		case .popular: return "인기 영화"
		case .topLated: return "최고 평가 영화"
		case .upcoming: return "개봉 예정 작"
		}
	}
	
	var partialUrlString: String {
		switch self {
		case .nowPlaying: return "/movie/now_playing"
		case .popular: return "/movie/popular"
		case .topLated: return "/movie/top_rated"
		case .upcoming: return "/movie/upcoming"
		}
	}
	
}
*/
