//
//  MBoxHomeView.swift
//  MBox
//
//  Created by YoonieMac on 4/18/26.
//

import SwiftUI


/// 앱의 홈화면을 구성하는 View
/// 영화 데이터를 카테고리별로 표시하고, My List 화면으로의 네비게이션 기능 포함
struct MBoxHomeView: View {
	
	// MARK: - Properties
	@EnvironmentObject private var vm: MovieViewModel  // ViewModel객체
	@State private var selectedMovie: Movie? = nil // 선택 영화 데이터
	@State private var isNavigatingToMyList: Bool = false // My List 화면으로 전환 상태
	
	// MARK: - Body
    var body: some View {
		NavigationStack {
			ZStack {
				//backgroundColor
				Color.ccBlack.ignoresSafeArea()
				
				// MARK: - Content
				VStack(spacing: 0) {
					header // 헤더 영역
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 10) {
							// 렌덤으로 선택된 HeroCell
							if let randomMovie = vm.randomNowPlayingMovie {
								heroCell(movie: randomMovie)
									.padding(.bottom, 20)
							}
							
							// 카테고리별 영화 리스트
							categoryRows
							
						} //:VSTACK
						.padding(.top, 10)
					} //:SCROLL
				} //:VSTACK
				
			} //:ZSTACK
			.foregroundStyle(.ccWhite)
			.sheet(item: $selectedMovie) { movie in
				// 영화 클릭시 상세보기 화면으로 이동
				MovieDetailView(movie: movie)
			}
			.background(
				NavigationLink("", destination: MyListView(), isActive: $isNavigatingToMyList)
					.hidden()
			)
			
		}//: NavigationStack
    }//:body
	
	
	
	// MARK: - Extension
	/// 헤더 영역
	private var header: some View {
		// Header 영역
		HStack(spacing: 20) {
			//로고
			HStack(spacing: 8) {
				Text("M")
					.foregroundStyle(.ccDarkRed) // M 부분 빨간색
					.font(.largeTitle)
				Text("BOX")
					.font(.title)
					.fontWeight(.bold)
					.kerning(3)
			} //:HSTACK
			.hLeading() // 왼쪽 정렬
			
			// My List로 이동 버튼
			Button {
				// TODO: My List View로 전환
				isNavigatingToMyList = true // MyListView로 전환
			} label: {
				Image(systemName: "pencil.and.list.clipboard")
			}
			.font(.title2)
			
		} //:HSTACK
		.padding(.horizontal, 20)
	}
	
	/// 렌덤으로 선택된 HeroCell
	private func heroCell(movie: Movie) -> some View {
		MBoxHeroCell(
			imageName: movie.posterURL?.absoluteString ?? "", // 영화 포스터 URL
			title: movie.title, // 영화 제목
			onBackgroundPressed: { // 배경 클릭 시 상세보기로 이동
				selectedMovie = movie
			},
			onDetailPressed: { // 버튼 클릭 시 상세보기로 이동
				selectedMovie = movie
			}
		)
	}
	
	/// 카테고리별 영화 리스트
	private var categoryRows: some View {
		LazyVStack(spacing: 15) {
			// 현재 상영중 섹션
			categoryRow(
				title: "현재 상영 중",
				movies: vm.nowPlayingMovies,
				onScrolledAtEnd: {
					vm.fetchNowPlayingMovies(page: vm.nextNowPlayingPage)
				}
			)
			// 인기작 섹션
			categoryRow(
				title: "인기작",
				movies: vm.popularMovies,
				onScrolledAtEnd: {
					vm.fetchPopularMovies(page: vm.nextpopularPage)
				}
			)
			// 별점 순위 섹션
			categoryRow(
				title: "별점 순",
				movies: vm.topRatedMovies,
				onScrolledAtEnd: {
					vm.fetchTopRatedMovies(page: vm.nextTopRatedPage)
				}
			)
			// 곧 상영 예정 섹션
			categoryRow(
				title: "상영 예정작",
				movies: vm.upComingMovies,
				onScrolledAtEnd: {
					vm.fetchUpComingMovies(page: vm.nextUpComingPage)
				}
			)
			
		} //:VSTACK
	}
	
	/// 단일 카테고리의 영화 리스트
	/// - parameter:
	/// 	- title: 카테고리 제목
	/// 	- movies: 해당 카테고리에 포함된 영화 리스트
	/// 	- onScrolledAtEnd: 무한 스크롤 트리거
	/// @escaping 클로져가 함수 실행이 끝난 후에도 호출될 수 있게 함
	/// 여기서는 onScrolledAtEnd 클로져가 마지막 스크롤이 끝날 때 외부에서 호출될 수 있게 만듦
	private func categoryRow(title: String, movies: [Movie], onScrolledAtEnd: @escaping () -> Void) -> some View {
		VStack(alignment: .leading, spacing: 5) {
			// 카테고리 제목
			Text(title)
				.font(.title)
			// 가로 스크롤 영화 리스트
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: 15) {
					ForEach(movies) { movie in
						MBoxMovieCell(
							imageName: movie.posterURL?.absoluteString ?? "",
							title: movie.title
						)
						.onAppear {
							// 무한 스크롤 트리거
							if movie == movies.last {
								onScrolledAtEnd()
							}
						}
						.onTapGesture {
							selectedMovie = movie
						}
					} //:LOOP
				} //:HSTACK
			} //:SCROLL
		} //:VSTACK
	}
	
}

#Preview {
    MBoxHomeView()
		.environmentObject(MovieViewModel())
}
