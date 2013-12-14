khi = angular.module 'khi', []

khi.config ['$provide', ($provide) ->
    $provide.decorator '$rootScope', ['$delegate', ($delegate) ->
        Object.defineProperty $delegate.constructor.prototype, '$onRootScope', {
            value: (name, listener) ->
                unsubscribe = $delegate.$on name, listener
                @$on '$destroy', unsubscribe
            ,
            enumerable: false
        }

        $delegate
    ]
]

# services

khi.factory 'Projects', ->
    defaultImg = 'code.png'

    [
        title: 'Sample'
        desc: 'This is a sample project'
        img: 'code.png'
        link: 'http://google.com'
    ,
        title: 'Sample 2'
        desc: 'This is another sample project'
        img: 'code.png'
        link: 'http://google.com'
    ,
        title: 'Sample Github'
        desc: 'This is a sample github project'
        img: 'code.png'
        github: 'http://github.com'
    ]

khi.factory 'FeedService', ['$http', '$rootScope', ($http, $rootScope) ->

    {
        posts: null,
        get: ->
            me = this
            $http.jsonp('https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=JSON_CALLBACK&q=http://blog.keats.me/rss').then (res) ->
                me.posts = res.data.responseData.feed.entries
                $rootScope.$emit 'posts.updated'
    }
]

# directives

khi.filter 'backgroundimage', ->
    (t) ->
        t = t.split('"')[1]
        t = t.replace /http/g, 'https'

# controllers

khi.controller 'HomePageCtrl', ['$scope', 'Projects', 'FeedService', ($scope, Projects, FeedService) ->
    $scope.projects = Projects
    FeedService.get()
    $scope.blogposts = FeedService.posts
    $scope.$onRootScope 'posts.updated', ->
        $scope.blogposts = FeedService.posts
]

khi.controller 'WorkPageCtrl', ['$scope', 'Projects', ($scope, Projects) ->
    $scope.projects = Projects
]

khi.controller 'ResumePageCtrl', ['$scope', ($scope) ->
    $scope.jobs = [
        start: 'May 2010'
        end: 'Present'
        place: 'Brooklyn, NY'
        role: 'Freelance Web Designer'
        company: 'Self Employed'
        desc: 'For the past few years, I\'ve been building websites and web apps for freelance clients in San Francisco, New York, and Tokyo. Though I\'m most comfortable with front-end design and development, I\'ve done some full-stack work with Ruby and Nodejs as well as CMS\'s like Drupal, Wordpress, and Shopify'
        subjobs: [
            start: 'July 2013'
            end: 'Present'
            place: 'New York, NY'
            role: 'Front-End Web Developer'
            company: 'Bolster'
            desc: 'I joined Bolster (a startup involved in managing construction projects) as the first front-end developer, and built web applications using AngularJS, LESS, and a grunt-based workflow.'
        ,
            start: 'Dec. 2012'
            end: 'July 2013'
            place: 'New York, NY'
            role: 'Front-End Web Developer'
            company: 'Busker.fm'
            desc: 'At Busker, a music startup, I built SpineJS-based web apps for consumers, artists, and record labels. I learned a lot about Ruby and Sinatra working with a back-end developer, and cemented my advocacy of non-blocking user interfaces (also known as asynchronous UI) and AGILE development.'
        ,
            start: 'July 2012'
            end: 'Dec. 2012'
            place: 'New York, NY'
            role: 'Front-End Web Developer'
            company: 'Barrel'
            desc: 'At Barrel, I built responsive websites on Wordpress, Shopify, and other CMS\'s. I also assisted in the development and maintenance of Phonegap-wrapped mobile web apps.'
        ,
            start: 'March 2011'
            end: 'June 2012'
            place: 'New York, NY'
            role: 'User Experience Engineer'
            company: 'Credit Suisse'
            desc: 'I was part of a three-person development team that built internal and external web apps using ExtJS. We also led mobile web development efforts company-wide, and created and maintained a robust API for client widgets.'
        ,
            start: 'Oct. 2010'
            end: 'Jan. 2011'
            place: 'New York, NY'
            role: 'SCRUM Master / Drupal Developer'
            company: 'Ology Media'
            desc: 'I developed custom modules for a Drupal-based social networking site, and set up an AGILE development workflow.'
        ]
    ,
        start: 'Aug. 2008'
        end: 'May 2010'
        place: 'CA and NY'
        role: 'IT Consultant'
        company: 'Self Employed'
        desc: 'Before shifting focus to web design and development, I worked as a freelance IT consultant for small and medium businesses in Rochester, NY and the Bay Area. I focused on networking, troubleshooting, and linux rollouts, and I\'m both Sonicwall and A+ certified.'
        subjobs: [
            start: 'Jan. 2010'
            end: 'May 2010'
            place: 'Rochester, NY'
            role: 'Level III Systems Engineer'
            company: 'Kriterium, LLC'
            desc: 'At Kriterum, I provided IT managed solutions to medium and large business clients. This included traveling to server rollouts along the Eastern Seaboard, compiling technical documentation, and a lot of network cable crimping.'
        ,
            start: 'Dec. 2009'
            end: 'May 2010'
            place: 'Rochester, NY'
            role: 'Systems Administrator'
            company: 'RIT Center for Computational Relativity and Gravitation'
            desc: 'The RIT CCRG is a small research group that uses supercomputers to model the collisions of galaxies and black holes. I didn\'t work on that directly, but I maintained their webservers, fileservers, backup systems, and website.'
        ,
            start: 'March 2009'
            end: 'Nov. 2009'
            place: 'Oakland, CA'
            role: 'Technical Support Lead'
            company: 'Maestro Conference'
            desc: 'I joined Maestro Conference as one of their first hires, and set up their support workflow and technical documentation. I sat in on development meetings, and was introduced to both AGILE methodologies and automated testing.'
        ,
            start: 'Oct. 2008'
            end: 'Jan. 2009'
            place: 'Rochester, NY'
            role: 'Tier 1 Technical Support'
            company: 'Eastman Kodak Company'
            desc: 'I did a brief stint in call-center technical support, and lobbied for Linux driver support for Kodak\'s printers. We all know how that turned out.'
        ]
    ,
        start: 'March 2008'
        end: 'Aug. 2008'
        place: 'San Ramon, CA'
        role: 'Tier 3 Technical Support'
        company: 'Fask-Teks, Inc.'
        desc: 'At Fast-Teks, I did on-call tech support and hardware/software installation for homes and small businesses. We were also subcontracted by Dell, Inc. to do installation and troubleshooting.'
    ,
        start: 'July 2006'
        end: 'March 2008'
        place: 'San Ramon, CA'
        role: 'Shift Supervisor / IT Manager'
        company: 'Country Club Cleaners'
        desc: 'I started at this dry cleaners working the front desk, and eventually became the senior customer service employee in charge of two locations and 14 delivery routes. By the end I was assisting the CEO and President with business-level IT decisions and spent most of my time training employees and providing tech support.'
    ,
        start: 'June 2004'
        end: 'Aug. 2005'
        place: 'Providence, RI'
        role: 'Stock Clerk'
        company: 'Adler\'s Hardware'
        desc: 'Though I\'ve been helping out around the family jewelry store since I was a kid, my first full-time job was at 14. To this day I have no idea how I managed to convince them to let a 14 year old work in a hardware store full of heavy equipment, sharp object, and power tools.'
    ]

    $scope.volunteering = [
        img: 'pax_prime_logo.jpg'
        imgAlt: 'Penny Arcade Expo'
        title: 'Enforcer'
        time: '3 years'
    ,
        img: 'pax_east_logo.jpg'
        imgAlt: 'PAX East'
        title: 'Enforcer'
        time: '3 years'
    ,
        img: 'toracon_logo.jpg'
        imgAlt: 'Tora Con'
        title: 'Volunteer'
        time: '2 years'
    ,
        img: 'connecticon_logo.png'
        imgAlt: 'Connecticon'
        title: 'Volunteer'
        time: '1 year'
    ]

    $scope.interests = [
        img: 'shacktac_logo.png'
        imgAlt: 'Shack Tactical'
        desc: 'I play in a large (~170 member) gaming group. We\'ve been featured in PC Gamer, Polygon, and other gaming news media.'
    ,
        img: 'eclipse.jpg'
        imgAlt: 'Boardgames'
        desc: 'I\'m really into European boardgames, and am a fan of indie pen and paper RPGs.'
    ]
]

khi.controller 'ContactSectionCtrl', ['$scope', ($scope) ->
    $scope.socialButtons = [
        icon: 'appdotnet'
        service: 'App.net'
        name: '@keats'
        link: 'http://alpha.app.net/keats'
    ,
        icon: 'googleplus'
        service: 'Google Plus'
        name: 'Nelson Pecora'
        link: 'https://plus.google.com/+NelsonPecora/about'
    ,
        icon: 'octocat'
        service: 'Github'
        name: 'Yoshokatana'
        link: 'https://github.com/yoshokatana'
    ,
        icon: 'tumblr'
        service: 'Blog'
        name: 'blog.keats.me'
        link: 'http://blog.keats.me'
    ,
        icon: 'twitter'
        service: 'Twitter'
        name: '@yoshokatana'
        link: 'http://twitter.com/yoshokatana'
    ,
        icon: 'facebook'
        service: 'Facebook'
        name: 'Yoshokatana'
        link: 'http://facebook.com/yoshokatana'
    ,
        icon: 'stackoverflow'
        service: 'Stack Overflow'
        name: 'Yoshokatana'
        link: 'http://stackoverflow.com/users/516719/yoshokatana'
    ,
        icon: 'pinboard'
        service: 'Pinboard'
        name: 'Yoshokatana'
        link: 'http://pinboard.in/yoshokatana'
    ]
]