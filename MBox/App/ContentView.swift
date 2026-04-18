//
//  ContentView.swift
//  MBox
//
//  Created by yoonie on 4/17/26.
//

import SwiftUI


struct ContentView: View {
	
	@StateObject private var vm: MovieViewModel = .init()
	
	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				//에러 메시지가 있는 경우
				if let errorMessage = vm.errorMessage {
					Text("Error: \(errorMessage)")
				}
				
				Text("최신 개봉작")
					.font(.largeTitle)
				ForEach(vm.nowPlayingMovies) { movie in
					Text(movie.title)
				}
				
				Text("인기 영화")
					.font(.largeTitle)
				ForEach(vm.popularMovies) { movie in
					Text(movie.title)
				}
				
				Text("최고 평점 영화")
					.font(.largeTitle)
				ForEach(vm.topRatedMovies) { movie in
					Text(movie.title)
				}
				
				Text("개봉 예정 영화")
					.font(.largeTitle)
				ForEach(vm.upComingMovies) { movie in
					Text(movie.title)
				}
			}
		}
	}
}


/*
 struct ContentView: View {
	 
	 @State private var vm: MovieViewModel = .init()
	 
	 var body: some View {
		 ScrollView {
			 VStack(spacing: 20) {
				 if let errorMessage = vm.errorMessage {
					 Text("Error: \(errorMessage)")
						 .font(.headline)
				 }
				 
				 ForEach(MovieLists.allCases, id: \.self) { movieList in
					 
					 Text(movieList.description)
						 .font(.largeTitle)
					 switch movieList {
					 case .nowPlaying:
						 ForEach(vm.nowPlayingMovies, id: \.id) { movie in
							 Text(movie.title)
						 }
					 case .popular:
						 ForEach(vm.popularMovies, id: \.id) { movie in
							 Text(movie.title)
						 }
					 case .topLated:
						 ForEach(vm.topRatedMovies, id: \.id) { movie in
							 Text(movie.title)
						 }
					 case .upcoming:
						 ForEach(vm.upcomingMovies, id: \.id) { movie in
							 Text(movie.title)
						 }
					 }
				 }
			 }
		 } //:SCROLL
	 }
 }

 */

#Preview {
    ContentView()
}
