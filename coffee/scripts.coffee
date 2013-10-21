khi = angular.module 'khi', []

# services

khi.factory 'Projects', ->
	defaultImg = 'code.png'

	[
		title: 'Sample'
		desc: 'This is a sample project'
		img: 'img.png'
		link: 'http://google.com'
	,
		title: 'Sample Github'
		desc: 'This is a sample github project'
		img: 'img.png'
		github: 'http://github.com'
	]

# directives

# controllers

khi.controller 'HomePageCtrl', ['$scope', 'Projects', ($scope, Projects) ->
	$scope.projects = Projects
	$scope.blogposts = []
]

khi.controller 'WorkPageCtrl', ['$scope', 'Projects', ($scope, Projects) ->
	$scope.projects = Projects
]

khi.controller 'ResumePageCtrl', ['$scope', ($scope) ->
	$scope.jobs = [
		start: ''
		end: ''
		place: ''
		role: ''
		company: ''
		desc: ''
		subjobs: [
			start: ''
			end: ''
			place: ''
			role: ''
			company: ''
			desc: ''
		]
	]
]

khi.controller 'ContactSectionCtrl', ['$scope', ($scope) ->
	
]