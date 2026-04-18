//
//  MovieViewModel.swift
//  MBox
//
//  Created by YoonieMac on 4/18/26.
//

import Foundation
import Combine
import Observation



// MARK: - MovieViewModel
/// TMDB APi를 통해 영화 데이터를 관리하고 Core Data와 상호작용하는 ViewModel
final class MovieViewModel: ObservableObject {
	
	// MARK: - Published Properties
	// 각 분류에 따른 영화 목록
	@Published var nowPlayingMovies: [Movie] = [] // 최신 개봉작 목록
	@Published var popularMovies: [Movie] = [] // 인기 영화 목록
	@Published var topRatedMovies: [Movie] = [] // 최고 평점 영화 목록
	@Published var upComingMovies: [Movie] = [] // 개봉 예정 영화 목록
	
	// 에러 메시지
	@Published var errorMessage: String? = nil // 에러 메시지 (에러 발생 시 표시)
	
	// 페이지 관리 변수
	@Published var nextNowPlayingPage: Int = 1
	@Published var nextpopularPage: Int = 1
	@Published var nextTopRatedPage: Int = 1
	@Published var nextUpComingPage: Int = 1
	
	// 인스턴스 -> 싱글톤
	private let networkManager = NetworkManager() // NetworkManager 인스턴스
	private var cancellables = Set<AnyCancellable>()
	
	// random으로 선택된 최신 개봉작 영화
	var randomNowPlayingMovie: Movie? {
		return nowPlayingMovies.randomElement()
	}
	
	// MARK: - Initializer
	/// ViewModel 초기화 시 각 영화 데이터를 로드함
	init() {
		fetchNowPlayingMovies()
		fetchPopularMovies()
		fetchTopRatedMovies()
		fetchUpComingMovies()
	}
	
	// MARK: - Fetch Methods
	/// 최신 개봉작 데이터를 TMDB API에서 가져옴
	/// - parameter: page 요청할 페이지 번호 (기본값 : 1)
	func fetchNowPlayingMovies(page: Int = 1) {
		networkManager.fetchNowPlayingMovies(page: page)
		// 1. Combine의 sink 구독을 통해 API 호출 결과 처리
			.sink(
				receiveCompletion: handleCompletion, // 네트워크 작업의 성공 / 실패를 처리하는 클로져
				receiveValue: { [weak self] movies in // 네트워크 호출의 성공 결과로 받은 데이터를 처리
					// 2. self 를 약하게 참조하여 강한 순환 참조 방지
					guard let self else {return}
					
					// 3. 받아온 영화 데이터를 최신 개봉작 목록에 업데이트 함
					// - self.nowPlayingMovies 를 업데이트하며, 첫 페이지의 경우에는 기존 데이터에 새로운 데이터를 덮어 씌우고 이후의 페이지인 경우는 기존 데이터에 새로운 데이터를 추가함.
					// & 표시는 swift에서 inout 파라미터의 인자를 나타냄. inout은 사용된 함수에서 변수의 값을 직접 수정하려면 호출 시 변수 이름 앞에 &을 붙여야 함
					self.updateMovieList(targetMovies: &nowPlayingMovies, movies: movies, page: page)
					
					// 4. 다음 페이지를 요청할 수 있도록 페이지 번호를 증가시킴
					self.nextNowPlayingPage += 1
				}
			)
		// 5. Combine 구독을 cancellables에 저장하여(계약서 저장) 메모리에서 관리하고, 뷰모델이 해제되면 자동으로 구독 취소함
			.store(in: &cancellables)
	}
	
	/// 인기 영화 데이터를 TMDB API에서 가져옴
	func fetchPopularMovies(page: Int = 1) {
		networkManager.fetchPopularMovies(page: page)
			.sink(
				receiveCompletion: handleCompletion,
				receiveValue: { [weak self] movies in
					guard let self else {return}
					self.updateMovieList(
						targetMovies: &popularMovies,
						movies: movies,
						page: page
					)
					self.nextpopularPage += 1
				}
			)
			.store(in: &cancellables)
	}
	
	/// 최고 평점 영화 데이터를 TMDB API에서 가져옴
	func fetchTopRatedMovies(page: Int = 1) {
		networkManager.fetchTopRatedMovies(page: page)
			.sink(
				receiveCompletion: handleCompletion,
				receiveValue: { [weak self] movies in
					guard let self else {return}
					self.updateMovieList(
						targetMovies: &topRatedMovies,
						movies: movies,
						page: page
					)
				}
			)
			.store(in: &cancellables)
	}
	
	/// 개봉 예정 영화 데이터를 TMDB API에서 가져옴
	func fetchUpComingMovies(page: Int = 1) {
		networkManager.fetchUpComingMovies(page: page)
			.sink(
				receiveCompletion: handleCompletion,
				receiveValue: { [weak self] movies in
					guard let self else {return}
					self.updateMovieList(
						targetMovies: &upComingMovies,
						movies: movies,
						page: page
					)
				}
			)
			.store(in: &cancellables)
	}
	
	// MARK: - Private Methods
	/// Combine 완료 이벤트 처리
	/// - parameter: completion 완료 이벤트 -> errorMessage에 내용 담기
	func handleCompletion(_ completion: Subscribers.Completion<Error>) {
		if case .failure(let failure) = completion {
			errorMessage = failure.localizedDescription
		}
	}
	
	/// 영화 목록을 업데이트 (페이지에 따라 덮어 쓰기 또는 추가)
	/// - parameter
	/// 	- targetList : 업데이트 할 영화 목록 (inout 매개변수로 함수 내에서 수정 가능, 즉 메개변수가 let이 아닌 var)
	/// 	- movies: 새로 가져온 영화 데이터
	/// 	- page: 현재 페이지 번호 (1이면 덮어쓰고, 1보다 크면 기존 목록에 추가)
	private func updateMovieList(targetMovies: inout [Movie], movies: [Movie], page: Int) {
		if page == 1 {
			targetMovies = movies // 첫 페이지일 경우, 기존 데이터를 덮어씀
		} else {
			targetMovies.append(contentsOf: movies) // 그 이외의 경우 데이터를 기존 목록에 추가
		}
	}
}



/*
 
 // MARK: - ViewModel(Observable)
 @Observable
 final class MovieViewModel {
	 
	 // MARK: - 각 [Movie] 빈배열 4개 / errormessage / nextPage / publisher / cancellables
	 var nowPlayingMovies: [Movie] = []
	 var popularMovies: [Movie] = []
	 var topRatedMovies: [Movie] = []
	 var upcomingMovies: [Movie] = []
	 
	 var errorMessage: String? = nil
	 
	 let networkManager = NetworkManager()
	 var cancellables = Set<AnyCancellable>()
	 
	 var nextPageTuple: (nowPlaying: Int, popular: Int, topRated: Int, upcoming: Int) = (nowPlaying: 1, popular: 1, topRated: 1, upcoming: 1)
	 
	 init() {
		 for sortedMovie in MovieLists.allCases {
			 self.fetchMovieData(movieLists: sortedMovie)
		 }
	 }
	 
	 // MARK: - fetchMovieData
	 func fetchMovieData(movieLists: MovieLists, page: Int = 1) {
		 self.networkManager.sortedMovies(movieLists: movieLists, page: page)
			 .sink(
				 receiveCompletion: handleCompletion,
				 receiveValue: { [weak self] movies in
					 guard let self else {return}
					 switch movieLists {
					 case .nowPlaying:
						 self.makeTheListOfMovie(targetMovies: &nowPlayingMovies, movies: movies, page: page)
						 self.nextPageTuple.nowPlaying += 1
					 case .popular:
						 self.makeTheListOfMovie(targetMovies: &popularMovies, movies: movies, page: page)
						 self.nextPageTuple.popular += 1
					 case .topLated:
						 self.makeTheListOfMovie(targetMovies: &topRatedMovies, movies: movies, page: page)
						 self.nextPageTuple.topRated += 1
					 case .upcoming:
						 self.makeTheListOfMovie(targetMovies: &upcomingMovies, movies: movies, page: page)
						 self.nextPageTuple.upcoming += 1
					 }
				 }
			 )
			 .store(in: &cancellables)
	 }
	 
	 func handleCompletion(_ completion: Subscribers.Completion<Error>) {
		 switch completion {
		 case .finished:
			 break
		 case .failure(let failure):
			 self.errorMessage = failure.localizedDescription
		 }
	 }
	 
	 func makeTheListOfMovie(targetMovies: inout [Movie], movies: [Movie], page: Int) {
		 if page == 1 {
			 targetMovies = movies
		 } else {
			 targetMovies.append(contentsOf: movies)
		 }
	 }
 }
 */

